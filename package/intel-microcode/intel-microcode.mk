################################################################################
#
# intel-microcode
#
################################################################################

INTEL_MICROCODE_VERSION = 20180807a
INTEL_MICROCODE_SOURCE = microcode-$(INTEL_MICROCODE_VERSION).tgz
INTEL_MICROCODE_SITE = https://downloadmirror.intel.com/28087/eng
INTEL_MICROCODE_STRIP_COMPONENTS = 0
INTEL_MICROCODE_LICENSE = PROPRIETARY
INTEL_MICROCODE_LICENSE_FILES = license
INTEL_MICROCODE_REDISTRIBUTE = NO

define INTEL_MICROCODE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/intel-ucode
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/lib/firmware/intel-ucode \
		$(@D)/intel-ucode/*
endef

$(eval $(generic-package))
