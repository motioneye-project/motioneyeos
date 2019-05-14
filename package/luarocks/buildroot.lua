
--- Module implementing the LuaRocks "buildroot" command.
local buildroot = {}

local dir = require("luarocks.dir")
local fs = require("luarocks.fs")
local util = require("luarocks.util")
local queries = require("luarocks.queries")
local search = require("luarocks.search")
local download = require("luarocks.download")
local fetch = require("luarocks.fetch")

buildroot.help_summary = "generate buildroot package files of a rock."
buildroot.help_arguments = "rockname [brname]"
buildroot.help = [[
This addon generates Buildroot package files of a rock.
First argument is the name of a rock, the second argument is optional
and needed when Buildroot uses another name (usually prefixed by lua-).
Files are generated with the source content of the rock and more
especially the rockspec. So, the rock is downloaded and unpacked.
]]

local function brname (name)
   return name:upper():gsub('-', '_')
end

local function brlicense (license)
   if license:match('MIT/X') then
      return 'MIT'
   end
   return license
end

local function wrap (txt, max)
   local lines = {}
   local line = ''
   for word in txt:gmatch('(%S+)') do
      if line:len() + word:len() > max - 1 then
          lines[#lines+1] = line
          line = ''
      end
      if line == '' then
         line  = word
      else
         line = line .. ' ' .. word
      end
   end
   lines[#lines+1] = line
   return lines
end

local function get_external_dependencies (rockspec)
   local t = {}
   for k in pairs(rockspec.external_dependencies or {}) do
      k = k:lower()
      if fs.is_dir('package/' .. k) then
         t[#t+1] = k
      else
         t[#t+1] = 'lib' .. k
         if not fs.is_dir('package/lib' .. k) then
            util.printout('unkwown external dependency: ' .. k)
         end
      end
   end
   table.sort(t)
   return t
end

local function get_dependencies (rockspec)
   local t = {}
   for i = 1, #rockspec.dependencies do
      local dep = tostring(rockspec.dependencies[i]):match('^(%S+)')
      if dep ~= 'lua' then
         dep = dep:gsub('_', '-')
         if fs.is_dir('package/lua-' .. dep) then
            t[#t+1] = 'lua-' .. dep
         else
            t[#t+1] = dep
            if not fs.is_dir('package/' .. dep) then
               util.printout('unkwown dependency: ' .. dep)
            end
         end
      end
   end
   table.sort(t)
   return t
end

function get_digest (file)
   local absname = fs.absolute_name(file)
   local pipe = io.popen('sha256sum ' .. fs.Q(absname))
   local line = pipe:read('*l')
   pipe:close()
   local computed = line and line:match('(' .. ('%x'):rep(64) .. ')')
   if computed then
      return computed
   else
      return nil, "Failed to compute SHA256 hash for file " .. absname
   end
end

local function generate_config (rockspec, lcname)
   local ucname = brname(lcname)
   local only_luajit = rockspec.package:match('^lj')
   local summary = rockspec.description.summary
   if not summary then
      summary = '???'
   elseif not summary:match('%.%s*$') then
      summary = summary:gsub('%s*$', '.')
   end
   local homepage = rockspec.description.homepage or '???'
   local external_dependencies = get_external_dependencies(rockspec)
   local dependencies = get_dependencies(rockspec)
   local fname = 'package/' .. lcname .. '/Config.in'
   local f = assert(io.open(fname, 'w'))
   util.printout('write ' .. fname)
   f:write('config BR2_PACKAGE_' .. ucname .. '\n')
   f:write('\tbool "' .. lcname .. '"\n')
   if only_luajit then
      f:write('\tdepends on BR2_PACKAGE_LUAJIT\n')
   end
   for i = 1, #external_dependencies do
      f:write('\tselect BR2_PACKAGE_' .. brname(external_dependencies[i]) .. '\n')
   end
   for i = 1, #dependencies do
      f:write('\tselect BR2_PACKAGE_' .. brname(dependencies[i]) .. ' # runtime\n')
   end
   f:write('\thelp\n')
   f:write('\t  ' .. table.concat(wrap(summary, 62), '\n\t  ') .. '\n')
   f:write('\n\t  ' .. homepage .. '\n')
   if only_luajit then
      f:write('\ncomment "' .. lcname .. ' needs LuaJIT"\n')
      f:write('\tdepends on !BR2_PACKAGE_LUAJIT\n')
   end
   f:close()
end

local function generate_mk (rockspec, lcname, licenses)
   local function escape (s)
      return s:gsub('-', '%%-'):gsub('%.', '%%.')
   end

   local ucname = brname(lcname)
   local need_name_upstream = false
   local need_version_upstream = false
   local name_upstream = rockspec.package
   local version = rockspec.version
   local version_upstream = version:match('^([^-]+)-')
   local revision = version:match('-(%d+)$')
   local license = rockspec.description.license
   local subdir = rockspec.source.dir
   if subdir then
      local root = subdir:match('^(.-)-' .. escape(version) .. '$')
      if root then
         subdir = root .. '-$(' .. ucname .. '_VERSION)'
      end
      root = subdir:match('^(.--[Vv])' .. escape(version_upstream) .. '$')
      if root then
         need_version_upstream = true
         subdir = root .. '$(' .. ucname .. '_VERSION_UPSTREAM)'
      end
      root = subdir:match('^(.-)-' .. escape(version_upstream) .. '$')
      if root then
         if root == lcname then
            subdir = nil
         elseif root == name_upstream then
            subdir = nil
            need_name_upstream = true
         else
            need_version_upstream = true
            subdir = root .. '-$(' .. ucname .. '_VERSION_UPSTREAM)'
         end
      end
   end
   local external_dependencies = get_external_dependencies(rockspec)
   local fname = 'package/' .. lcname .. '/' .. lcname .. '.mk'
   local f = assert(io.open(fname, 'w'))
   util.printout('write ' .. fname)
   f:write('################################################################################\n')
   f:write('#\n')
   f:write('# ' .. lcname .. '\n')
   f:write('#\n')
   f:write('################################################################################\n')
   f:write('\n')
   if need_version_upstream then
      f:write(ucname .. '_VERSION_UPSTREAM = ' .. version_upstream .. '\n')
      f:write(ucname .. '_VERSION = $(' .. ucname .. '_VERSION_UPSTREAM)-' .. revision .. '\n')
   else
      f:write(ucname .. '_VERSION = ' .. version .. '\n')
   end
   if lcname ~= name_upstream:lower() or need_name_upstream then
      f:write(ucname .. '_NAME_UPSTREAM = ' .. name_upstream .. '\n')
   end
   if subdir then
      f:write(ucname .. '_SUBDIR = ' .. subdir .. '\n')
   end
   if license then
      f:write(ucname .. '_LICENSE = ' .. brlicense(license) .. '\n')
   end
   if #licenses == 1 then
      f:write(ucname .. '_LICENSE_FILES = $(' .. ucname .. '_SUBDIR)/' .. licenses[1] .. '\n')
   elseif #licenses > 1 then
      f:write(ucname .. '_LICENSE_FILES =')
      for i = 1, #licenses do
         local file = licenses[i]
         f:write(' \\\n\t$(' .. ucname .. '_SUBDIR)/' .. file)
      end
      f:write('\n')
   end
   if #external_dependencies > 0 then
      f:write(ucname .. '_DEPENDENCIES = ' .. table.concat(external_dependencies, ' ') .. '\n')
   end
   f:write('\n$(eval $(luarocks-package))\n')
   f:close()
end

local function generate_hash (rockspec, lcname, rock_file, licenses, digest)
   local subdir = rockspec.source.dir
   local fname = 'package/' .. lcname .. '/' .. lcname .. '.hash'
   local f = assert(io.open(fname, 'w'))
   util.printout('write ' .. fname)
   f:write('# computed by luarocks/buildroot\n')
   f:write('sha256 ' .. digest[rock_file] .. '  ' .. rock_file .. '\n')
   for i = 1, #licenses do
      local file = licenses[i]
      f:write('sha256 ' .. digest[file] .. '  ' .. subdir .. '/' .. file .. '\n')
   end
   f:close()
end

--- Driver function for the "buildroot" command.
-- @param rockname string: the name of a rock to be fetched and unpacked.
-- @param brname string: the name used by Buildroot (optional)
-- @return boolean: true if successful
function buildroot.command(flags, rockname, fsname)
   if type(rockname) ~= 'string' then
      return nil, "Argument missing. "..util.see_help('buildroot')
   end
   fsname = fsname or rockname
   assert(type(fsname) == 'string')

   local query = queries.new(rockname:lower(), nil, false, 'src')
   local url, err = search.find_suitable_rock(query)
   if not url then
      return nil, "Could not find a result named " .. tostring(query) .. ": " .. err
   end
   local rock_file = dir.base_name(url)

   local temp_dir, err = fs.make_temp_dir(rockname)
   if not temp_dir then
      return nil, "Failed creating temporary dir: " .. err
   end
   local ok, err = fs.change_dir(temp_dir)
   if not ok then return nil, err end

   ok = fs.download(url, rock_file, true)
   if not ok then
      return nil, "Failed downloading " .. url
   end

   local digest = {}
   digest[rock_file], err = get_digest(rock_file)
   if not digest[rock_file] then return nil, err end
   ok, err = fs.unzip(rock_file)
   if not ok then return nil, err end

   local rockspec_file = rock_file:gsub('%.src%.rock$', '.rockspec')
   local rockspec, err = fetch.load_rockspec(rockspec_file)
   if not rockspec then
      return nil, "Error loading rockspec: " .. err
   end
   if rockspec.source.file then
      ok, err = fs.unpack_archive(rockspec.source.file)
      if not ok then return nil, err end
   end

   if rockspec.source.dir ~= '.' then
      fs.copy(rockspec.local_abs_filename, rockspec.source.dir, 'read')
   end

   local build_type = rockspec.build.type
   if build_type ~= 'none' and build_type ~= 'builtin' and build_type ~= 'module' then
      util.printout('[' .. rockspec.package .. "] build_type '" .. build_type .. "' not supported")
   end

   local licenses = {}
   ok, err = fs.change_dir(rockspec.source.dir)
   if not ok then return nil, err end
   local files = fs.find()
   for i = 1, #files do
      local v = files[i]
      if v == 'COPYING'
         or v == 'COPYRIGHT'
         or v:match('^LICENSE') then
         licenses[#licenses+1] = v
         digest[v], err = get_digest(v)
         if not digest[v] then return nil, err end
      end
   end
   if #licenses == 0 then
      for i = 1, #files do
         local v = files[i]
         if v:match('^doc/LICENSE')
            or v:match('^doc/license')
            or v:match('^doc/us/license') then
            licenses[#licenses+1] = v
            digest[v], err = get_digest(v)
            if not digest[v] then return nil, err end
         end
      end
   end
   fs.pop_dir()
   table.sort(licenses)

   fs.pop_dir()
   ok, err = fs.make_dir('package/' .. fsname:lower())
   if not ok then return nil, err end

   generate_config(rockspec, fsname:lower())
   generate_mk(rockspec, fsname:lower(), licenses)
   generate_hash(rockspec, fsname:lower(), rock_file, licenses, digest)

   return true
end

return buildroot
