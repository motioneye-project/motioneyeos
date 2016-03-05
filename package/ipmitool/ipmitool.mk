################################################################################
#
# ipmitool
#
################################################################################

IPMITOOL_VERSION = 1.8.15
IPMITOOL_SOURCE = ipmitool-$(IPMITOOL_VERSION).tar.bz2
IPMITOOL_SITE = http://downloads.sourceforge.net/project/ipmitool/ipmitool/$(IPMITOOL_VERSION)
IPMITOOL_LICENSE = BSD-3c
IPMITOOL_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_IPMITOOL_LANPLUS),y)
IPMITOOL_DEPENDENCIES += openssl
else
IPMITOOL_CONF_OPTS += --disable-intf-lanplus
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
IPMITOOL_DEPENDENCIES += readline
endif

ifeq ($(BR2_PACKAGE_IPMITOOL_IPMIEVD),)
define IPMITOOL_REMOVE_IPMIEVD
	$(RM) -f $(TARGET_DIR)/usr/sbin/ipmievd
endef
IPMITOOL_POST_INSTALL_TARGET_HOOKS += IPMITOOL_REMOVE_IPMIEVD
endif

$(eval $(autotools-package))
