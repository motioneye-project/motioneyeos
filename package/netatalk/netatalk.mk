################################################################################
#
# netatalk
#
################################################################################

NETATALK_VERSION = 3.0
NETATALK_SITE = http://downloads.sourceforge.net/project/netatalk/netatalk/$(NETATALK_VERSION)
NETATALK_SOURCE = netatalk-$(NETATALK_VERSION).tar.bz2

NETATALK_AUTORECONF = YES
NETATALK_CONFIG_SCRIPTS = netatalk-config

NETATALK_DEPENDENCIES = host-pkgconf openssl berkeleydb libgcrypt libgpg-error
NETATALK_CONF_ENV += CC="$(TARGET_CC) -std=gnu99"
NETATALK_CONF_OPT += --with-cnid-cdb-backend \
	--with-bdb=$(STAGING_DIR)/usr \
	--disable-zeroconf \
	--with-ssl-dir=$(STAGING_DIR)/usr \
	--with-libgcrypt-dir=$(STAGING_DIR)/usr \
	--with-shadow \
	--disable-shell-check \
	--without-kerberos \
	--without-pam

ifeq ($(BR2_PACKAGE_CUPS),y)
	NETATALK_DEPENDENCIES += cups
	NETATALK_CONF_ENV += ac_cv_path_CUPS_CONFIG=$(STAGING_DIR)/usr/bin/cups-config
	NETATALK_CONF_OPT += --enable-cups
else
	NETATALK_CONF_OPT += --disable-cups
endif

define NETATALK_INSTALL_EXTRA_FILES
	[ -f $(TARGET_DIR)/etc/init.d/S50netatalk ] || \
		$(INSTALL) -m 0755 -D package/netatalk/S50netatalk \
			$(TARGET_DIR)/etc/init.d/S50netatalk
endef

NETATALK_POST_INSTALL_TARGET_HOOKS += NETATALK_INSTALL_EXTRA_FILES

$(eval $(autotools-package))
