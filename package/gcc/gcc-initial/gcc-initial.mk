################################################################################
#
# gcc-initial
#
################################################################################

GCC_INITIAL_VERSION = $(GCC_VERSION)
GCC_INITIAL_SITE = $(GCC_SITE)
GCC_INITIAL_SOURCE = $(GCC_SOURCE)

HOST_GCC_INITIAL_DEPENDENCIES = $(HOST_GCC_COMMON_DEPENDENCIES)

HOST_GCC_INITIAL_EXCLUDES = $(HOST_GCC_EXCLUDES)
HOST_GCC_INITIAL_POST_EXTRACT_HOOKS += HOST_GCC_FAKE_TESTSUITE

ifneq ($(call qstrip, $(BR2_XTENSA_CORE_NAME)),)
HOST_GCC_INITIAL_POST_EXTRACT_HOOKS += HOST_GCC_XTENSA_OVERLAY_EXTRACT
endif

HOST_GCC_INITIAL_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_INITIAL_SUBDIR = build

HOST_GCC_INITIAL_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

# gcc on ARC has a bug: in its libgcc, even when no C library is
# available (--with-newlib is passed, and therefore inhibit_libc is
# defined), it tries to use the C library for the libgmon
# library. Since it's not needed in gcc-initial, we disabled it here.
ifeq ($(BR2_GCC_VERSION_4_8_ARC),y)
define HOST_GCC_INITIAL_DISABLE_LIBGMON
	$(SED) 's/crtbeginS.o libgmon.a crtg.o/crtbeginS.o crtg.o/' \
		$(@D)/libgcc/config.host
endef
HOST_GCC_INITIAL_POST_PATCH_HOOKS += HOST_GCC_INITIAL_DISABLE_LIBGMON
HOST_GCC_INITIAL_POST_RSYNC_HOOKS += HOST_GCC_INITIAL_DISABLE_LIBGMON
endif

HOST_GCC_INITIAL_CONF_OPTS = \
	$(HOST_GCC_COMMON_CONF_OPTS) \
	--enable-languages=c \
	--disable-shared \
	--without-headers \
	--disable-threads \
	--with-newlib \
	--disable-largefile \
	--disable-nls \
	$(call qstrip,$(BR2_EXTRA_GCC_CONFIG_OPTIONS))

HOST_GCC_INITIAL_CONF_ENV = \
	$(HOST_GCC_COMMON_CONF_ENV)

HOST_GCC_INITIAL_MAKE_OPTS = $(HOST_GCC_COMMON_MAKE_OPTS) all-gcc
HOST_GCC_INITIAL_INSTALL_OPTS = install-gcc

ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_GCC_INITIAL_MAKE_OPTS += all-target-libgcc
HOST_GCC_INITIAL_INSTALL_OPTS += install-target-libgcc
endif

HOST_GCC_INITIAL_TOOLCHAIN_WRAPPER_ARGS += $(HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS)
HOST_GCC_INITIAL_POST_BUILD_HOOKS += TOOLCHAIN_BUILD_WRAPPER
HOST_GCC_INITIAL_POST_INSTALL_HOOKS += HOST_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS

$(eval $(host-autotools-package))
