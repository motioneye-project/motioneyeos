################################################################################
#
# netatalk
#
################################################################################

NETATALK_VERSION = 3.1.7
NETATALK_SITE = http://downloads.sourceforge.net/project/netatalk/netatalk/$(NETATALK_VERSION)
NETATALK_SOURCE = netatalk-$(NETATALK_VERSION).tar.bz2
# For 0001-Fix-setting-of-LD_LIBRARY_FLAGS-shlibpath_var.patch
NETATALK_AUTORECONF = YES
NETATALK_CONFIG_SCRIPTS = netatalk-config
NETATALK_DEPENDENCIES = host-pkgconf openssl berkeleydb libgcrypt libgpg-error \
	libevent
NETATALK_LICENSE = GPLv2+, LGPLv3+, MIT-like
NETATALK_LICENSE_FILES = COPYING COPYRIGHT

# Don't run ldconfig!
NETATALK_CONF_ENV += CC="$(TARGET_CC) -std=gnu99" \
	ac_cv_path_NETA_LDCONFIG=""
NETATALK_CONF_OPTS += --with-cnid-cdb-backend \
	--with-bdb=$(STAGING_DIR)/usr \
	--with-ssl-dir=$(STAGING_DIR)/usr \
	--with-libgcrypt-dir=$(STAGING_DIR)/usr \
	--with-shadow \
	--disable-shell-check \
	--without-kerberos \
	--without-pam \
	--with-libevent=no \
	--with-dtrace=no \
	--with-mysql-config=no

ifeq ($(BR2_PACKAGE_ACL),y)
	NETATALK_DEPENDENCIES += acl
else
	NETATALK_CONF_OPTS += --with-acls=no
endif

ifeq ($(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_DBUS),yy)
	NETATALK_DEPENDENCIES += avahi
	NETATALK_CONF_OPTS += --enable-zeroconf=$(STAGING_DIR)/usr
else
	NETATALK_CONF_OPTS += --disable-zeroconf
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
	NETATALK_DEPENDENCIES += cups
	NETATALK_CONF_ENV += ac_cv_path_CUPS_CONFIG=$(STAGING_DIR)/usr/bin/cups-config
	NETATALK_CONF_OPTS += --enable-cups
else
	NETATALK_CONF_OPTS += --disable-cups
endif

define NETATALK_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/netatalk/S50netatalk \
		$(TARGET_DIR)/etc/init.d/S50netatalk
endef

$(eval $(autotools-package))
