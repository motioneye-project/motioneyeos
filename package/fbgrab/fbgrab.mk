FBGRAB_VERSION = 1.0
FBGRAB_SOURCE = fbgrab-$(FBGRAB_VERSION).tar.gz
FBGRAB_SITE = http://hem.bredband.net/gmogmo/fbgrab
FBGRAB_DEPENDENCIES = libpng

define FBGRAB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define FBGRAB_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/fbgrab $(TARGET_DIR)/usr/bin/fbgrab
endef

define FBGRAB_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/fbgrab
endef

$(eval $(generic-package))
