################################################################################
# CMake package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for CMake packages. It should be used for all
# packages that use CMake as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this CMake infrastructure requires
# the .mk file to only specify metadata informations about the
# package: name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default CMake behaviour. The
# package can also define some post operation hooks.
#
################################################################################

################################################################################
# inner-cmake-package -- defines how the configuration, compilation and
# installation of a CMake package should be done, implements a few hooks to
# tune the build process and calls the generic package infrastructure to
# generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including an HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the package directory prefix
#  argument 5 is the type (target or host)
################################################################################

define inner-cmake-package

$(2)_CONF_ENV			?=
$(2)_CONF_OPT			?=
$(2)_MAKE			?= $(MAKE)
$(2)_MAKE_ENV			?=
$(2)_MAKE_OPT			?=
$(2)_INSTALL_HOST_OPT		?= install
$(2)_INSTALL_STAGING_OPT	?= DESTDIR=$$(STAGING_DIR) install
$(2)_INSTALL_TARGET_OPT		?= DESTDIR=$$(TARGET_DIR) install
$(2)_CLEAN_OPT			?= clean

$(2)_SRCDIR			= $$($(2)_DIR)/$($(2)_SUBDIR)
$(2)_BUILDDIR			= $$($(2)_SRCDIR)

#
# Configure step. Only define it if not already defined by the package
# .mk file. And take care of the differences between host and target
# packages.
#
ifndef $(2)_CONFIGURE_CMDS
ifeq ($(5),target)

# Configure package for target
define $(2)_CONFIGURE_CMDS
	(cd $$($$(PKG)_BUILDDIR) && \
	rm -f CMakeCache.txt && \
	$$($$(PKG)_CONF_ENV) $(HOST_DIR)/usr/bin/cmake $$($$(PKG)_SRCDIR) \
		-DCMAKE_TOOLCHAIN_FILE="$$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake" \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		$$($$(PKG)_CONF_OPT) \
	)
endef
else

# Configure package for host
define $(2)_CONFIGURE_CMDS
	(cd $$($$(PKG)_BUILDDIR) && \
	rm -f CMakeCache.txt && \
	$(HOST_DIR)/usr/bin/cmake $$($$(PKG)_SRCDIR) \
		-DCMAKE_INSTALL_SO_NO_EXE=0 \
		-DCMAKE_FIND_ROOT_PATH="$$(HOST_DIR)" \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="BOTH" \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY="BOTH" \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="BOTH" \
		-DCMAKE_INSTALL_PREFIX="$$(HOST_DIR)/usr" \
		$$($$(PKG)_CONF_OPT) \
	)
endef
endif
endif

# This must be repeated from inner-generic-package, otherwise we only get
# host-cmake in _DEPENDENCIES because of the following line
$(2)_DEPENDENCIES ?= $(filter-out $(1),$(patsubst host-host-%,host-%,$(addprefix host-,$($(3)_DEPENDENCIES))))

$(2)_DEPENDENCIES += host-cmake

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
ifeq ($(5),target)
define $(2)_BUILD_CMDS
	$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) -C $$($$(PKG)_BUILDDIR)
endef
else
define $(2)_BUILD_CMDS
	$(HOST_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) -C $$($$(PKG)_BUILDDIR)
endef
endif
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	$(HOST_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) $$($$(PKG)_INSTALL_HOST_OPT) -C $$($$(PKG)_BUILDDIR)
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) $$($$(PKG)_INSTALL_STAGING_OPT) -C $$($$(PKG)_BUILDDIR)
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) $$($$(PKG)_INSTALL_TARGET_OPT) -C $$($$(PKG)_BUILDDIR)
endef
endif

#
# Clean step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_CLEAN_CMDS
define $(2)_CLEAN_CMDS
	-$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) $$($$(PKG)_CLEAN_OPT) -C $$($$(PKG)_BUILDDIR)
endef
endif

#
# Uninstall from staging step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_UNINSTALL_STAGING_CMDS
define $(2)_UNINSTALL_STAGING_CMDS
	(cd $$($$(PKG)_BUILDDIR) && sed "s:\(.*\):$$(STAGING_DIR)\1:" install_manifest.txt | xargs rm -f)
endef
endif

#
# Uninstall from target step. Only define it if not already defined
# by the package .mk file.
#
ifndef $(2)_UNINSTALL_TARGET_CMDS
define $(2)_UNINSTALL_TARGET_CMDS
	(cd $$($$(PKG)_BUILDDIR) && sed "s:\(.*\):$$(TARGET_DIR)\1:" install_manifest.txt | xargs rm -f)
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4),$(5))

endef

################################################################################
# cmake-package -- the target generator macro for CMake packages
################################################################################

cmake-package = $(call inner-cmake-package,$(call pkgname),$(call UPPERCASE,$(call pkgname)),$(call UPPERCASE,$(call pkgname)),$(call pkgparentdir),target)
host-cmake-package = $(call inner-cmake-package,host-$(call pkgname),$(call UPPERCASE,host-$(call pkgname)),$(call UPPERCASE,$(call pkgname)),$(call pkgparentdir),host)

################################################################################
# Generation of the CMake toolchain file
################################################################################

$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake:
	@mkdir -p $(@D)
	@echo -en "\
	set(CMAKE_SYSTEM_NAME Linux)\n\
	set(CMAKE_C_COMPILER $(TARGET_CC_NOCCACHE))\n\
	set(CMAKE_CXX_COMPILER $(TARGET_CXX_NOCCACHE))\n\
	set(CMAKE_C_FLAGS \"\$${CMAKE_C_FLAGS} $(TARGET_CFLAGS)\" CACHE STRING \"Buildroot CFLAGS\" FORCE)\n\
	set(CMAKE_CXX_FLAGS \"\$${CMAKE_CXX_FLAGS} $(TARGET_CXXFLAGS)\" CACHE STRING \"Buildroot CXXFLAGS\" FORCE)\n\
	set(CMAKE_INSTALL_SO_NO_EXE 0)\n\
	set(CMAKE_PROGRAM_PATH \"$(HOST_DIR)/usr/bin\")\n\
	set(CMAKE_FIND_ROOT_PATH \"$(STAGING_DIR)\")\n\
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)\n\
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)\n\
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)\n\
	set(ENV{PKG_CONFIG_SYSROOT_DIR} \"$(STAGING_DIR)\")\n\
	" > $@

