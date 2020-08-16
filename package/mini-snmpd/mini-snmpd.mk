################################################################################
#
# mini-snmpd
#
################################################################################

MINI_SNMPD_VERSION = 1.6
MINI_SNMPD_SITE = $(call github,troglobit,mini-snmpd,v$(MINI_SNMPD_VERSION))
MINI_SNMPD_LICENSE = GPL-2.0
MINI_SNMPD_LICENSE_FILES = COPYING
MINI_SNMPD_AUTORECONF = YES
MINI_SNMPD_DEPENDENCIES = host-pkgconf

define MINI_SNMPD_INSTALL_ETC_DEFAULT
	$(INSTALL) -D -m 644 package/mini-snmpd/mini-snmpd \
		$(TARGET_DIR)/etc/default/mini-snmpd
endef

MINI_SNMPD_POST_INSTALL_TARGET_HOOKS += MINI_SNMPD_INSTALL_ETC_DEFAULT

$(eval $(autotools-package))
