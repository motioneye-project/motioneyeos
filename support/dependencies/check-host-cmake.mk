# Versions before 3.0 are affected by the bug described in
# https://git.busybox.net/buildroot/commit/?id=ef2c1970e4bff3be3992014070392b0e6bc28bd2
# and fixed in upstream CMake in version 3.0:
# https://cmake.org/gitweb?p=cmake.git;h=e8b8b37ef6fef094940d3384df5a1d421b9fa568
#
# Set this to either 3.0 or higher, depending on the highest minimum
# version required by any of the packages bundled in Buildroot. If a
# package is bumped or a new one added, and it requires a higher
# version, our cmake infra will catch it and whine.
#
BR2_CMAKE_VERSION_MIN = 3.1

BR2_CMAKE ?= cmake
ifeq ($(call suitable-host-package,cmake,\
	$(BR2_CMAKE) $(BR2_CMAKE_VERSION_MIN)),)
BR2_CMAKE = $(HOST_DIR)/usr/bin/cmake
BR2_CMAKE_HOST_DEPENDENCY = host-cmake
endif
