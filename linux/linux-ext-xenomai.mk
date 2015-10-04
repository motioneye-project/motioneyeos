################################################################################
# Linux Adeos/Xenomai extensions
#
# Patch the linux kernel with xenomai extension
################################################################################

LINUX_EXTENSIONS += xenomai

# Adeos patch version
XENOMAI_ADEOS_PATCH = $(call qstrip,$(BR2_LINUX_KERNEL_EXT_XENOMAI_ADEOS_PATCH))
ifeq ($(XENOMAI_ADEOS_PATCH),)
XENOMAI_ADEOS_OPTS = --default
else
XENOMAI_ADEOS_OPTS = --adeos=$(XENOMAI_ADEOS_PATCH)
endif

# Prepare kernel patch
define XENOMAI_PREPARE_KERNEL
	$(XENOMAI_DIR)/scripts/prepare-kernel.sh \
		--linux=$(LINUX_DIR) \
		--arch=$(KERNEL_ARCH) \
		$(XENOMAI_ADEOS_OPTS) \
		--verbose
endef
