################################################################################
#
# cmake
#
################################################################################

CMAKE_VERSION_MAJOR = 3.6
CMAKE_VERSION = $(CMAKE_VERSION_MAJOR).3
CMAKE_SITE = https://cmake.org/files/v$(CMAKE_VERSION_MAJOR)
CMAKE_LICENSE = BSD-3c
CMAKE_LICENSE_FILES = Copyright.txt

# CMake is a particular package:
# * CMake can be built using the generic infrastructure or the cmake one.
#   Since Buildroot has no requirement regarding the host system cmake
#   program presence, it uses the generic infrastructure to build the
#   host-cmake package, then the (target-)cmake package can be built
#   using the cmake infrastructure;
# * CMake bundles its dependencies within its sources. This is the
#   reason why the host-cmake package has no dependencies:, whereas
#   the (target-)cmake package has a lot of dependencies, using only
#   the system-wide libraries instead of rebuilding and statically
#   linking with the ones bundled into the CMake sources.

CMAKE_DEPENDENCIES = zlib jsoncpp libcurl libarchive expat bzip2 xz

CMAKE_CONF_OPTS = \
	-DKWSYS_LFS_WORKS=TRUE \
	-DKWSYS_CHAR_IS_SIGNED=TRUE \
	-DCMAKE_USE_SYSTEM_LIBRARIES=1 \
	-DCTEST_USE_XMLRPC=OFF \
	-DBUILD_CursesDialog=OFF

# Get rid of -I* options from $(HOST_CPPFLAGS) to prevent that a
# header available in $(HOST_DIR)/usr/include is used instead of a
# CMake internal header, e.g. lzma* headers of the xz package
HOST_CMAKE_CFLAGS = $(shell echo $(HOST_CFLAGS) | sed -r "s%$(HOST_CPPFLAGS)%%")
HOST_CMAKE_CXXFLAGS = $(shell echo $(HOST_CXXFLAGS) | sed -r "s%$(HOST_CPPFLAGS)%%")

define HOST_CMAKE_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CMAKE_CFLAGS)" \
		./bootstrap --prefix=$(HOST_DIR)/usr \
			--parallel=$(PARALLEL_JOBS) -- \
			-DCMAKE_C_FLAGS="$(HOST_CMAKE_CFLAGS)" \
			-DCMAKE_CXX_FLAGS="$(HOST_CMAKE_CXXFLAGS)" \
			-DCMAKE_EXE_LINKER_FLAGS="$(HOST_LDFLAGS)" \
			-DBUILD_CursesDialog=OFF \
	)
endef

define HOST_CMAKE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_CMAKE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install/fast
endef

define CMAKE_REMOVE_EXTRA_DATA
	rm $(TARGET_DIR)/usr/bin/{cmake,cpack}
	rm -fr $(TARGET_DIR)/usr/share/cmake-$(CMAKE_VERSION_MAJOR)/{completions,editors}
	rm -fr $(TARGET_DIR)/usr/share/cmake-$(CMAKE_VERSION_MAJOR)/{Help,include}
endef

define CMAKE_INSTALL_CTEST_CFG_FILE
	$(INSTALL) -m 0644 -D $(@D)/Modules/CMake.cmake \
		$(TARGET_DIR)/usr/share/cmake-$(CMAKE_VERSION_MAJOR)/Modules/CMake.cmake.ctest
endef

CMAKE_POST_INSTALL_TARGET_HOOKS += CMAKE_REMOVE_EXTRA_DATA
CMAKE_POST_INSTALL_TARGET_HOOKS += CMAKE_INSTALL_CTEST_CFG_FILE

define CMAKE_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(HOST_MAKE_ENV) DESTDIR=$(TARGET_DIR) \
		cmake -P cmake_install.cmake \
	)
endef

$(eval $(cmake-package))
$(eval $(host-generic-package))
