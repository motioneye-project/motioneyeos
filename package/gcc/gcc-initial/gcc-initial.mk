################################################################################
#
# gcc-initial
#
################################################################################

GCC_INITIAL_VERSION = $(GCC_VERSION)
GCC_INITIAL_SITE = $(GCC_SITE)
GCC_INITIAL_SOURCE = $(GCC_SOURCE)

# We do not have a 'gcc' package per-se; we only have two incarnations,
# gcc-initial and gcc-final. gcc-initial is just am internal step that
# users should not care about, while gcc-final is the one they shall see.
HOST_GCC_INITIAL_DL_SUBDIR = gcc

HOST_GCC_INITIAL_DEPENDENCIES = $(HOST_GCC_COMMON_DEPENDENCIES)

HOST_GCC_INITIAL_EXCLUDES = $(HOST_GCC_EXCLUDES)

ifneq ($(ARCH_XTENSA_OVERLAY_FILE),)
HOST_GCC_INITIAL_POST_EXTRACT_HOOKS += HOST_GCC_XTENSA_OVERLAY_EXTRACT
HOST_GCC_INITIAL_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
endif

HOST_GCC_INITIAL_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_INITIAL_SUBDIR = build

HOST_GCC_INITIAL_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

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

HOST_GCC_INITIAL_MAKE_OPTS = $(HOST_GCC_COMMON_MAKE_OPTS) all-gcc all-target-libgcc
HOST_GCC_INITIAL_INSTALL_OPTS = install-gcc install-target-libgcc

HOST_GCC_INITIAL_TOOLCHAIN_WRAPPER_ARGS += $(HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS)
HOST_GCC_INITIAL_POST_BUILD_HOOKS += TOOLCHAIN_WRAPPER_BUILD
HOST_GCC_INITIAL_POST_INSTALL_HOOKS += TOOLCHAIN_WRAPPER_INSTALL
HOST_GCC_INITIAL_POST_INSTALL_HOOKS += HOST_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS

$(eval $(host-autotools-package))
