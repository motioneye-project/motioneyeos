-- BR cross-compilation
local function getenv (name) return os_getenv(name) or '' end
external_deps_dirs = { getenv('STAGING_DIR') .. [[/usr]] }
gcc_rpath = false
wrap_bin_scripts = false
