# Impersonate a Linux system. Afterall, that's what we are...
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM ${CMAKE_SYSTEM_NAME})
include(Platform/Linux)

# Override problematic settings, to avoid RPATH against host lib directories.
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB32_PATHS FALSE)
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS FALSE)
