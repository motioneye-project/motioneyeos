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
# the .mk file to only specify metadata information about the
# package: name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default CMake behaviour. The
# package can also define some post operation hooks.
#
################################################################################

# Set compiler variables.
ifeq ($(BR2_CCACHE),y)
CMAKE_HOST_C_COMPILER = $(HOST_DIR)/bin/ccache
CMAKE_HOST_CXX_COMPILER = $(HOST_DIR)/bin/ccache
CMAKE_HOST_C_COMPILER_ARG1 = $(HOSTCC_NOCCACHE)
CMAKE_HOST_CXX_COMPILER_ARG1 = $(HOSTCXX_NOCCACHE)
else
CMAKE_HOST_C_COMPILER = $(HOSTCC)
CMAKE_HOST_CXX_COMPILER = $(HOSTCXX)
endif

ifneq ($(QUIET),)
CMAKE_QUIET = -DCMAKE_RULE_MESSAGES=OFF -DCMAKE_INSTALL_MESSAGE=NEVER
endif

################################################################################
# inner-cmake-package -- defines how the configuration, compilation and
# installation of a CMake package should be done, implements a few hooks to
# tune the build process and calls the generic package infrastructure to
# generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-cmake-package

$(2)_CONF_ENV			?=
$(2)_CONF_OPTS			?=
$(2)_MAKE			?= $$(MAKE)
$(2)_MAKE_ENV			?=
$(2)_MAKE_OPTS			?=
$(2)_INSTALL_OPTS		?= install
$(2)_INSTALL_STAGING_OPTS	?= DESTDIR=$$(STAGING_DIR) install/fast
$(2)_INSTALL_TARGET_OPTS		?= DESTDIR=$$(TARGET_DIR) install/fast

$(2)_SRCDIR			= $$($(2)_DIR)/$$($(2)_SUBDIR)

$(3)_SUPPORTS_IN_SOURCE_BUILD ?= YES


ifeq ($$($(3)_SUPPORTS_IN_SOURCE_BUILD),YES)
$(2)_BUILDDIR			= $$($(2)_SRCDIR)
else
$(2)_BUILDDIR			= $$($(2)_SRCDIR)/buildroot-build
endif

#
# Configure step. Only define it if not already defined by the package
# .mk file. And take care of the differences between host and target
# packages.
#
ifndef $(2)_CONFIGURE_CMDS
ifeq ($(4),target)

# Configure package for target
define $(2)_CONFIGURE_CMDS
	(mkdir -p $$($$(PKG)_BUILDDIR) && \
	cd $$($$(PKG)_BUILDDIR) && \
	rm -f CMakeCache.txt && \
	PATH=$$(BR_PATH) \
	$$($$(PKG)_CONF_ENV) $$(BR2_CMAKE) $$($$(PKG)_SRCDIR) \
		-DCMAKE_TOOLCHAIN_FILE="$$(HOST_DIR)/share/buildroot/toolchainfile.cmake" \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		-DBUILD_DOC=OFF \
		-DBUILD_DOCS=OFF \
		-DBUILD_EXAMPLE=OFF \
		-DBUILD_EXAMPLES=OFF \
		-DBUILD_TEST=OFF \
		-DBUILD_TESTS=OFF \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=$$(if $$(BR2_STATIC_LIBS),OFF,ON) \
		$$(CMAKE_QUIET) \
		$$($$(PKG)_CONF_OPTS) \
	)
endef
else

# Configure package for host
define $(2)_CONFIGURE_CMDS
	(mkdir -p $$($$(PKG)_BUILDDIR) && \
	cd $$($$(PKG)_BUILDDIR) && \
	rm -f CMakeCache.txt && \
	PATH=$$(BR_PATH) \
	PKG_CONFIG="$$(PKG_CONFIG_HOST_BINARY)" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_LIBDIR="$$(HOST_DIR)/lib/pkgconfig:$$(HOST_DIR)/share/pkgconfig" \
	PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
	PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 \
	$$($$(PKG)_CONF_ENV) $$(BR2_CMAKE) $$($$(PKG)_SRCDIR) \
		-DCMAKE_INSTALL_SO_NO_EXE=0 \
		-DCMAKE_FIND_ROOT_PATH="$$(HOST_DIR)" \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="BOTH" \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY="BOTH" \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="BOTH" \
		-DCMAKE_INSTALL_PREFIX="$$(HOST_DIR)" \
		-DCMAKE_C_FLAGS="$$(HOST_CFLAGS)" \
		-DCMAKE_CXX_FLAGS="$$(HOST_CXXFLAGS)" \
		-DCMAKE_EXE_LINKER_FLAGS="$$(HOST_LDFLAGS)" \
		-DCMAKE_ASM_COMPILER="$$(HOSTAS)" \
		-DCMAKE_C_COMPILER="$$(CMAKE_HOST_C_COMPILER)" \
		-DCMAKE_CXX_COMPILER="$$(CMAKE_HOST_CXX_COMPILER)" \
		$(if $$(CMAKE_HOST_C_COMPILER_ARG1),\
			-DCMAKE_C_COMPILER_ARG1="$$(CMAKE_HOST_C_COMPILER_ARG1)" \
			-DCMAKE_CXX_COMPILER_ARG1="$$(CMAKE_HOST_CXX_COMPILER_ARG1)" \
		) \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		-DBUILD_DOC=OFF \
		-DBUILD_DOCS=OFF \
		-DBUILD_EXAMPLE=OFF \
		-DBUILD_EXAMPLES=OFF \
		-DBUILD_TEST=OFF \
		-DBUILD_TESTS=OFF \
		-DBUILD_TESTING=OFF \
		$$(CMAKE_QUIET) \
		$$($$(PKG)_CONF_OPTS) \
	)
endef
endif
endif

# Since some CMake modules (even upstream ones) use pgk_check_modules
# primitives to find {C,LD}FLAGS, add it to the dependency list.
$(2)_DEPENDENCIES += host-pkgconf

$(2)_DEPENDENCIES += $(BR2_CMAKE_HOST_DEPENDENCY)

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
ifeq ($(4),target)
define $(2)_BUILD_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) -C $$($$(PKG)_BUILDDIR)
endef
else
define $(2)_BUILD_CMDS
	$$(HOST_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) -C $$($$(PKG)_BUILDDIR)
endef
endif
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	$$(HOST_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) $$($$(PKG)_INSTALL_OPTS) -C $$($$(PKG)_BUILDDIR)
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) $$($$(PKG)_INSTALL_STAGING_OPTS) -C $$($$(PKG)_BUILDDIR)
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPTS) $$($$(PKG)_INSTALL_TARGET_OPTS) -C $$($$(PKG)_BUILDDIR)
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# cmake-package -- the target generator macro for CMake packages
################################################################################

cmake-package = $(call inner-cmake-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-cmake-package = $(call inner-cmake-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)

################################################################################
# Generation of the CMake toolchain file
################################################################################

# CMAKE_SYSTEM_PROCESSOR should match uname -m
ifeq ($(BR2_ARM_CPU_ARMV4),y)
CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT = armv4
else ifeq ($(BR2_ARM_CPU_ARMV5),y)
CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT = armv5
else ifeq ($(BR2_ARM_CPU_ARMV6),y)
CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT = armv6
else ifeq ($(BR2_ARM_CPU_ARMV7A),y)
CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT = armv7
else ifeq ($(BR2_ARM_CPU_ARMV8),y)
CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT = armv8
endif

ifeq ($(BR2_arm),y)
CMAKE_SYSTEM_PROCESSOR = $(CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT)l
else ifeq ($(BR2_armeb),y)
CMAKE_SYSTEM_PROCESSOR = $(CMAKE_SYSTEM_PROCESSOR_ARM_VARIANT)b
else ifeq ($(call qstrip,$(BR2_ARCH)),powerpc64)
CMAKE_SYSTEM_PROCESSOR = ppc64
else ifeq ($(call qstrip,$(BR2_ARCH)),powerpc64le)
CMAKE_SYSTEM_PROCESSOR = ppc64le
else
CMAKE_SYSTEM_PROCESSOR = $(BR2_ARCH)
endif

# In order to allow the toolchain to be relocated, we calculate the HOST_DIR
# based on the toolchainfile.cmake file's location: $(HOST_DIR)/share/buildroot
# In all the other variables, HOST_DIR will be replaced by RELOCATED_HOST_DIR,
# so we have to strip "$(HOST_DIR)/" from the paths that contain it.
$(HOST_DIR)/share/buildroot/toolchainfile.cmake:
	@mkdir -p $(@D)
	sed \
		-e 's#@@STAGING_SUBDIR@@#$(call qstrip,$(STAGING_SUBDIR))#' \
		-e 's#@@TARGET_CFLAGS@@#$(call qstrip,$(TARGET_CFLAGS))#' \
		-e 's#@@TARGET_CXXFLAGS@@#$(call qstrip,$(TARGET_CXXFLAGS))#' \
		-e 's#@@TARGET_FCFLAGS@@#$(call qstrip,$(TARGET_FCFLAGS))#' \
		-e 's#@@TARGET_LDFLAGS@@#$(call qstrip,$(TARGET_LDFLAGS))#' \
		-e 's#@@TARGET_CC@@#$(subst $(HOST_DIR)/,,$(call qstrip,$(TARGET_CC)))#' \
		-e 's#@@TARGET_CXX@@#$(subst $(HOST_DIR)/,,$(call qstrip,$(TARGET_CXX)))#' \
		-e 's#@@TARGET_FC@@#$(subst $(HOST_DIR)/,,$(call qstrip,$(TARGET_FC)))#' \
		-e 's#@@CMAKE_SYSTEM_PROCESSOR@@#$(call qstrip,$(CMAKE_SYSTEM_PROCESSOR))#' \
		-e 's#@@TOOLCHAIN_HAS_FORTRAN@@#$(if $(BR2_TOOLCHAIN_HAS_FORTRAN),1,0)#' \
		-e 's#@@CMAKE_BUILD_TYPE@@#$(if $(BR2_ENABLE_DEBUG),Debug,Release)#' \
		$(TOPDIR)/support/misc/toolchainfile.cmake.in \
		> $@

$(HOST_DIR)/share/buildroot/Platform/Buildroot.cmake:
	$(Q)$(INSTALL) -D -m 0644 support/misc/Buildroot.cmake $(@)
