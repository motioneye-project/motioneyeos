################################################################################
#
# Patch the linux kernel with Adeos/Xenomai extension
#
################################################################################

LINUX_EXTENSIONS += xenomai

# Adeos patch version
XENOMAI_ADEOS_PATCH = $(call qstrip,$(BR2_LINUX_KERNEL_EXT_XENOMAI_ADEOS_PATCH))

ifneq ($(filter ftp://% http://% https://%,$(XENOMAI_ADEOS_PATCH)),)
XENOMAI_ADEOS_PATCH_NAME = $(notdir $(XENOMAI_ADEOS_PATCH))
XENOMAI_ADEOS_PATCH_PATH = $(LINUX_DL_DIR)/$(XENOMAI_ADEOS_PATCH_NAME)
# check-package TypoInPackageVariable
LINUX_EXTRA_DOWNLOADS += $(XENOMAI_ADEOS_PATCH)
BR_NO_CHECK_HASH_FOR += $(XENOMAI_ADEOS_PATCH_NAME)
else
XENOMAI_ADEOS_PATCH_PATH = $(XENOMAI_ADEOS_PATCH)
endif

ifeq ($(XENOMAI_ADEOS_PATCH),)
XENOMAI_ADEOS_OPTS = --default
else
XENOMAI_ADEOS_OPTS = --adeos=$(XENOMAI_ADEOS_PATCH_PATH)
endif

# Prepare kernel patch
define XENOMAI_PREPARE_KERNEL
	$(XENOMAI_DIR)/scripts/prepare-kernel.sh \
		--linux=$(LINUX_DIR) \
		--arch=$(KERNEL_ARCH) \
		$(XENOMAI_ADEOS_OPTS) \
		--verbose
endef
