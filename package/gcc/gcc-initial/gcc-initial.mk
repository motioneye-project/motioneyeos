################################################################################
#
# gcc-initial
#
################################################################################

GCC_INITIAL_VERSION = $(GCC_VERSION)
GCC_INITIAL_SITE    = $(GCC_SITE)
GCC_INITIAL_SOURCE  = $(GCC_SOURCE)

HOST_GCC_INITIAL_DEPENDENCIES = $(HOST_GCC_COMMON_DEPENDENCIES)

HOST_GCC_INITIAL_EXTRACT_CMDS = $(HOST_GCC_EXTRACT_CMDS)

ifneq ($(call qstrip, $(BR2_XTENSA_CORE_NAME)),)
HOST_GCC_INITIAL_POST_EXTRACT_CMDS += HOST_GCC_XTENSA_OVERLAY_EXTRACT
endif

HOST_GCC_INITIAL_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_INITIAL_SUBDIR = build

HOST_GCC_INITIAL_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

HOST_GCC_INITIAL_CONF_OPT = \
	$(HOST_GCC_COMMON_CONF_OPT) \
	--enable-languages=c \
	--disable-shared \
	--without-headers \
	--with-newlib \
	--disable-largefile \
	--disable-nls \
	$(call qstrip,$(BR2_EXTRA_GCC_CONFIG_OPTIONS))

HOST_GCC_INITIAL_CONF_ENV = \
	$(HOST_GCC_COMMON_CONF_ENV)

HOST_GCC_INITIAL_MAKE_OPT = all-gcc
HOST_GCC_INITIAL_INSTALL_OPT = install-gcc

$(eval $(host-autotools-package))
