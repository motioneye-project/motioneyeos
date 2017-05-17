################################################################################
#
# fbgrab
#
################################################################################

FBGRAB_VERSION = 1.3
FBGRAB_SITE = http://fbgrab.monells.se
FBGRAB_DEPENDENCIES = libpng
FBGRAB_LICENSE = GPL-2.0
FBGRAB_LICENSE_FILES = COPYING

define FBGRAB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) fbgrab
endef

define FBGRAB_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/fbgrab $(TARGET_DIR)/usr/bin/fbgrab
endef

$(eval $(generic-package))
