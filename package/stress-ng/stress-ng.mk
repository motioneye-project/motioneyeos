################################################################################
#
# stress-ng
#
################################################################################

STRESS_NG_VERSION = 0.06.15
STRESS_NG_SITE = http://kernel.ubuntu.com/~cking/tarballs/stress-ng
STRESS_NG_LICENSE = GPLv2+
STRESS_NG_LICENSE_FILES = COPYING

STRESS_NG_DEPENDENCIES = attr keyutils

define STRESS_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# Don't use make install otherwise stress-ng will be rebuild without
# required link libraries if any. Furthermore, using INSTALL allow to
# set the file permission correcly on the target.
define STRESS_NG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/stress-ng $(TARGET_DIR)/usr/bin/stress-ng
endef

$(eval $(generic-package))
