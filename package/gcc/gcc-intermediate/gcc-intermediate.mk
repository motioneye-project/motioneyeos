################################################################################
#
# gcc-intermediate
#
################################################################################

GCC_INTERMEDIATE_VERSION = $(GCC_VERSION)
GCC_INTERMEDIATE_SITE    = $(GCC_SITE)
GCC_INTERMEDIATE_SOURCE  = $(GCC_SOURCE)

HOST_GCC_INTERMEDIATE_DEPENDENCIES = \
	$(HOST_GCC_COMMON_DEPENDENCIES) \
	$(BUILDROOT_LIBC)-configure

HOST_GCC_INTERMEDIATE_EXTRACT_CMDS = $(HOST_GCC_EXTRACT_CMDS)

ifneq ($(call qstrip, $(BR2_XTENSA_CORE_NAME)),)
HOST_GCC_INTERMEDIATE_POST_EXTRACT_CMDS += HOST_GCC_XTENSA_OVERLAY_EXTRACT
endif

HOST_GCC_INTERMEDIATE_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_INTERMEDIATE_SUBDIR = build

HOST_GCC_INTERMEDIATE_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

HOST_GCC_INTERMEDIATE_CONF_OPT = \
	$(HOST_GCC_COMMON_CONF_OPT) \
	--enable-languages=c \
	--disable-largefile \
	--disable-nls \
	$(call qstrip,$(BR2_EXTRA_GCC_CONFIG_OPTIONS))

HOST_GCC_INTERMEDIATE_MAKE_OPT = all-gcc
ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_GCC_INTERMEDIATE_MAKE_OPT += all-target-libgcc
endif

HOST_GCC_INTERMEDIATE_INSTALL_OPT = install-gcc
ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_GCC_INTERMEDIATE_INSTALL_OPT += install-target-libgcc
endif

$(eval $(host-autotools-package))
