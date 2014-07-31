################################################################################
#
# cmake
#
################################################################################

CMAKE_VERSION_MAJOR = 2.8
CMAKE_VERSION = $(CMAKE_VERSION_MAJOR).12.2
CMAKE_SITE = http://www.cmake.org/files/v$(CMAKE_VERSION_MAJOR)
CMAKE_LICENSE = BSD-3c
CMAKE_LICENSE_FILES = Copyright.txt

define HOST_CMAKE_CONFIGURE_CMDS
	(cd $(@D); \
		LDFLAGS="$(HOST_LDFLAGS)" \
		CFLAGS="$(HOST_CFLAGS)" \
		./bootstrap --prefix=$(HOST_DIR)/usr \
			--parallel=$(PARALLEL_JOBS) -- \
			-DCMAKE_C_FLAGS="$(HOST_CFLAGS)" \
			-DCMAKE_CXX_FLAGS="$(HOST_CXXFLAGS)" \
			-DCMAKE_EXE_LINKER_FLAGS="$(HOST_LDFLAGS)" \
			-DBUILD_CursesDialog=OFF \
	)
endef

define HOST_CMAKE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_CMAKE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(host-generic-package))
