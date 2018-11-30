-- BR cross-compilation
local function getenv (name) return os_getenv(name) or '' end
variables.LUA_INCDIR = getenv('STAGING_DIR') .. [[/usr/include]]
variables.LUA_LIBDIR = getenv('STAGING_DIR') .. [[/usr/lib]]
variables.CC = getenv('TARGET_CC')
variables.LD = getenv('TARGET_CC')
variables.CFLAGS = getenv('TARGET_CFLAGS')
variables.LIBFLAG = [[-shared ]] .. getenv('TARGET_LDFLAGS')
external_deps_dirs = { getenv('STAGING_DIR') .. [[/usr]] }
gcc_rpath = false
rocks_trees = { getenv('TARGET_DIR') .. [[/usr]] }
wrap_bin_scripts = false
deps_mode = [[none]]
