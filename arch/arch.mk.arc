ifeq ($(BR2_arc),y)

# -matomic is always required when the ARC core has the atomic extensions
ifeq ($(BR2_ARC_ATOMIC_EXT),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS = -matomic
endif

# By default MAXPAGESIZE for ARC is 8192 so for larger MMU pages
# it needs to be overridden.
ifeq ($(BR2_ARC_PAGE_SIZE_16K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=16384
endif

endif
