################################################################################
#
# fan-ctrl
#
################################################################################

# no release, so grab .c file directly from viewvc
FAN_CTRL_VERSION = 1.3
FAN_CTRL_SOURCE = fan-ctrl.c?revision=$(FAN_CTRL_VERSION)
FAN_CTRL_SITE = http://fan-ctrl.cvs.sourceforge.net/viewvc/fan-ctrl/fan-ctrl
FAN_CTRL_LICENSE = GPLv2+
FAN_CTRL_LICENSE_FILES = fan-ctrl.c

define FAN_CTRL_EXTRACT_CMDS
	cp $(DL_DIR)/$(FAN_CTRL_SOURCE) $(@D)/fan-ctrl.c
endef

define FAN_CTRL_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(@D)/fan-ctrl.c -o $(@D)/fan-ctrl
endef

define FAN_CTRL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/fan-ctrl $(TARGET_DIR)/usr/sbin/fan-ctrl
endef

$(eval $(generic-package))
