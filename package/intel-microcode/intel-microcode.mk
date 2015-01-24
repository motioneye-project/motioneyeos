################################################################################
#
# intel-microcode
#
################################################################################

INTEL_MICROCODE_VERSION = 20150107
INTEL_MICROCODE_SOURCE = microcode-$(INTEL_MICROCODE_VERSION).tgz
INTEL_MICROCODE_SITE = http://downloadmirror.intel.com/24616/eng
INTEL_MICROCODE_LICENSE = PROPRIETARY
INTEL_MICROCODE_LICENSE_FILES = license.txt
INTEL_MICROCODE_REDISTRIBUTE = NO

# N.B. Don't strip any path components during extraction.
define INTEL_MICROCODE_EXTRACT_CMDS
	gzip -d -c $(DL_DIR)/$(INTEL_MICROCODE_SOURCE) | \
	tar --strip-components=0 -C $(@D) -xf -
	head -n 33 $(@D)/microcode.dat > $(@D)/license.txt
endef

define INTEL_MICROCODE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/microcode.dat \
		$(TARGET_DIR)/usr/share/misc/intel-microcode.dat
endef

$(eval $(generic-package))
