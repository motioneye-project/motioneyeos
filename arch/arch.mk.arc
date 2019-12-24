ifeq ($(BR2_arc),y)

# -matomic is always required when the ARC core has the atomic extensions
ifeq ($(BR2_ARC_ATOMIC_EXT),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS = -matomic
endif

# Explicitly set LD's "max-page-size" instead of relying on some defaults
ifeq ($(BR2_ARC_PAGE_SIZE_4K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=4096
else ifeq ($(BR2_ARC_PAGE_SIZE_8K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=8192
else ifeq ($(BR2_ARC_PAGE_SIZE_16K),y)
ARCH_TOOLCHAIN_WRAPPER_OPTS += -Wl,-z,max-page-size=16384
endif

endif
