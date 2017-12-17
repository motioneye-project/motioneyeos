################################################################################
#
# nanocom
#
################################################################################

NANOCOM_VERSION = 1.0
NANOCOM_SOURCE = nanocom.tar.gz
NANOCOM_SITE = http://downloads.sourceforge.net/project/nanocom/nanocom/v$(NANOCOM_VERSION)
NANOCOM_STRIP_COMPONENTS = 0
NANOCOM_LICENSE = GPLv2+
NANOCOM_LICENSE_FILES = COPYING

define NANOCOM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" -C $(@D)
endef

define NANOCOM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/nanocom $(TARGET_DIR)/usr/bin/nanocom
endef

$(eval $(generic-package))
