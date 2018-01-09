################################################################################
#
# intel-microcode
#
################################################################################

INTEL_MICROCODE_VERSION = 20180108
INTEL_MICROCODE_SOURCE = microcode-$(INTEL_MICROCODE_VERSION).tgz
INTEL_MICROCODE_SITE = http://downloadmirror.intel.com/27431/eng
INTEL_MICROCODE_STRIP_COMPONENTS = 0
INTEL_MICROCODE_LICENSE = PROPRIETARY
INTEL_MICROCODE_LICENSE_FILES = license.txt
INTEL_MICROCODE_REDISTRIBUTE = NO

define INTEL_MICROCODE_EXTRACT_LICENSE
	head -n 33 $(@D)/microcode.dat > $(@D)/license.txt
endef

INTEL_MICROCODE_POST_EXTRACT_HOOKS += INTEL_MICROCODE_EXTRACT_LICENSE

define INTEL_MICROCODE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/microcode.dat \
		$(TARGET_DIR)/usr/share/misc/intel-microcode.dat
endef

$(eval $(generic-package))
