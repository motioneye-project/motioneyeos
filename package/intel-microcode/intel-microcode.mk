################################################################################
#
# intel-microcode
#
################################################################################

INTEL_MICROCODE_VERSION = microcode-20190514a
INTEL_MICROCODE_SITE = $(call github,intel,Intel-Linux-Processor-Microcode-Data-Files,$(INTEL_MICROCODE_VERSION))
INTEL_MICROCODE_LICENSE = PROPRIETARY
INTEL_MICROCODE_LICENSE_FILES = license
INTEL_MICROCODE_REDISTRIBUTE = NO

define INTEL_MICROCODE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/intel-ucode
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/lib/firmware/intel-ucode \
		$(@D)/intel-ucode/*
endef

$(eval $(generic-package))
