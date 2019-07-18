# -matomic is always required when the ARC core has the atomic extensions
ifeq ($(BR2_arc)$(BR2_ARC_ATOMIC_EXT),yy)
ARCH_TOOLCHAIN_WRAPPER_OPTS = -matomic
endif
