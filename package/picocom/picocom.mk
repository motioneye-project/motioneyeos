################################################################################
#
# picocom
#
################################################################################

PICOCOM_VERSION = 1.6
PICOCOM_SITE    = http://picocom.googlecode.com/files/

define PICOCOM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define PICOCOM_INSTALL_TARGET_CMDS
	install -D -m 0755 $(@D)/picocom $(TARGET_DIR)/usr/bin/picocom
endef

$(eval $(generic-package))
