################################################################################
#
# rustc
#
################################################################################

RUSTC_ARCH = $(call qstrip,$(BR2_PACKAGE_HOST_RUSTC_ARCH))
RUSTC_ABI = $(call qstrip,$(BR2_PACKAGE_HOST_RUSTC_ABI))

ifeq ($(BR2_PACKAGE_HOST_RUSTC_TARGET_ARCH_SUPPORTS),y)
RUSTC_TARGET_NAME = $(RUSTC_ARCH)-unknown-linux-gnu$(RUSTC_ABI)
endif

ifeq ($(HOSTARCH),x86)
RUSTC_HOST_ARCH = i686
else
RUSTC_HOST_ARCH = $(HOSTARCH)
endif

RUSTC_HOST_NAME = $(RUSTC_HOST_ARCH)-unknown-linux-gnu

$(eval $(host-virtual-package))
