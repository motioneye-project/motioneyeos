################################################################################
#
# intel-microcode
#
################################################################################

INTEL_MICROCODE_VERSION = 20200616
INTEL_MICROCODE_SITE = $(call github,intel,Intel-Linux-Processor-Microcode-Data-Files,microcode-$(INTEL_MICROCODE_VERSION))
INTEL_MICROCODE_LICENSE = PROPRIETARY
INTEL_MICROCODE_LICENSE_FILES = license
INTEL_MICROCODE_REDISTRIBUTE = NO
INTEL_MICROCODE_INSTALL_IMAGES = YES

define INTEL_MICROCODE_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/intel-ucode
	$(INSTALL) -m 0644 -t $(BINARIES_DIR)/intel-ucode \
		$(@D)/intel-ucode/*
endef

ifeq ($(BR2_PACKAGE_INTEL_MICROCODE_INSTALL_TARGET),y)
define INTEL_MICROCODE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/intel-ucode
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/lib/firmware/intel-ucode \
		$(@D)/intel-ucode/*
endef
else
INTEL_MICROCODE_INSTALL_TARGET = NO
endif

define INTEL_MICROCODE_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_MICROCODE)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MICROCODE_INTEL)
endef

$(eval $(generic-package))
