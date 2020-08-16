# Set this to either 3.10 or higher, depending on the highest minimum
# version required by any of the packages bundled in Buildroot. If a
# package is bumped or a new one added, and it requires a higher
# version, our cmake infra will catch it and build its own.
#
BR2_CMAKE_VERSION_MIN = 3.10

BR2_CMAKE_CANDIDATES ?= cmake cmake3
BR2_CMAKE ?= $(call suitable-host-package,cmake,\
	$(BR2_CMAKE_VERSION_MIN) $(BR2_CMAKE_CANDIDATES))
ifeq ($(BR2_CMAKE),)
BR2_CMAKE = $(HOST_DIR)/bin/cmake
BR2_CMAKE_HOST_DEPENDENCY = host-cmake
endif
