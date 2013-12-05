################################################################################
#
# fbgrab
#
################################################################################

FBGRAB_VERSION = 1.2
FBGRAB_SITE = http://fbgrab.monells.se
FBGRAB_DEPENDENCIES = libpng
FBGRAB_LICENSE = GPLv2
FBGRAB_LICENSE_FILES = COPYING

define FBGRAB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define FBGRAB_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/fbgrab $(TARGET_DIR)/usr/bin/fbgrab
endef

$(eval $(generic-package))
