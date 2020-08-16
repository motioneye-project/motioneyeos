-- BR host compilation
local function getenv (name) return os_getenv(name) or '' end
external_deps_dirs = { getenv('HOST_DIR') }
