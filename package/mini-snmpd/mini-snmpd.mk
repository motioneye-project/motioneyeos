################################################################################
#
# mini-snmpd
#
################################################################################

MINI_SNMPD_VERSION = 1.4
MINI_SNMPD_SITE = $(call github,troglobit,mini-snmpd,v$(MINI_SNMPD_VERSION))
MINI_SNMPD_LICENSE = GPL-2.0
MINI_SNMPD_LICENSE_FILES = COPYING
MINI_SNMPD_AUTORECONF = YES

define MINI_SNMPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/mini-snmpd/mini-snmpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mini-snmpd.service
endef

$(eval $(autotools-package))
