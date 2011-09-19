##################################################
# Linux Adeos/Xenomai extensions
#
# Patch the linux kernel with xenomai extension
##################################################

ifeq ($(BR2_LINUX_KERNEL_EXT_XENOMAI),y)
# Add dependency to xenomai (user-space) which provide ksrc part
LINUX_DEPENDENCIES += xenomai

# Adeos patch version
XENOMAI_ADEOS_PATCH = $(call qstrip,$(BR2_LINUX_KERNEL_EXT_XENOMAI_ADEOS_PATCH))
ifeq ($(XENOMAI_ADEOS_PATCH),)
XENOMAI_ADEOS_OPT = --default
else
XENOMAI_ADEOS_OPT = --adeos=$(XENOMAI_ADEOS_PATCH)
endif

# Prepare kernel patch
define XENOMAI_PREPARE_KERNEL
	$(XENOMAI_DIR)/scripts/prepare-kernel.sh \
		--linux=$(LINUX_DIR) \
		--arch=$(KERNEL_ARCH) \
		$(XENOMAI_ADEOS_OPT) \
		--verbose
endef

LINUX_PRE_PATCH_HOOKS += XENOMAI_PREPARE_KERNEL

endif #BR2_LINUX_EXT_XENOMAI
