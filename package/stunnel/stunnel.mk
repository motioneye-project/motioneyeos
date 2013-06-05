################################################################################
#
# stunnel
#
################################################################################

STUNNEL_VERSION = 4.55
STUNNEL_SITE = http://ftp.nluug.nl/pub/networking/stunnel
STUNNEL_DEPENDENCIES = openssl
STUNNEL_CONF_OPT = --with-ssl=$(STAGING_DIR)/usr --with-threads=fork
STUNNEL_LICENSE = GPLv2+
STUNNEL_LICENSE_FILES = COPYING COPYRIGHT.GPL

define STUNNEL_INSTALL_CONF_SCRIPT
	$(INSTALL) -m 0755 -D package/stunnel/S50stunnel $(TARGET_DIR)/etc/init.d/S50stunnel
	[ -f $(TARGET_DIR)/etc/stunnel/stunnel.conf ] || \
		$(INSTALL) -m 0644 -D $(@D)/tools/stunnel.conf \
			$(TARGET_DIR)/etc/stunnel/stunnel.conf
	rm -f $(TARGET_DIR)/etc/stunnel/stunnel.conf-sample
endef

STUNNEL_POST_INSTALL_TARGET_HOOKS += STUNNEL_INSTALL_CONF_SCRIPT

$(eval $(autotools-package))
