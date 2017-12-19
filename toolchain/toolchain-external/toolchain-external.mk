################################################################################
#
# toolchain-external
#
################################################################################

TOOLCHAIN_EXTERNAL_ADD_TOOLCHAIN_DEPENDENCY = NO

# musl does not provide an implementation for sys/queue.h or sys/cdefs.h.
# So, add the musl-compat-headers package that will install those files,
# into the staging directory:
#   sys/queue.h:  header from NetBSD
#   sys/cdefs.h:  minimalist header bundled in Buildroot
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
TOOLCHAIN_EXTERNAL_DEPENDENCIES += musl-compat-headers
endif

$(eval $(virtual-package))

# Ensure the external-toolchain package has a prefix defined.
# This comes after the virtual-package definition, which checks the provider.
ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
ifeq ($(call qstrip,$(BR2_TOOLCHAIN_EXTERNAL_PREFIX)),)
$(error No prefix selected for external toolchain package $(BR2_PACKAGE_PROVIDES_TOOLCHAIN_EXTERNAL). Configuration error)
endif
endif

include $(sort $(wildcard toolchain/toolchain-external/*/*.mk))
