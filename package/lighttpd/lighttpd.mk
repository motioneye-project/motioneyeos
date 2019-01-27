################################################################################
#
# lighttpd
#
################################################################################

LIGHTTPD_VERSION_MAJOR = 1.4
LIGHTTPD_VERSION = $(LIGHTTPD_VERSION_MAJOR).53
LIGHTTPD_SOURCE = lighttpd-$(LIGHTTPD_VERSION).tar.xz
LIGHTTPD_SITE = http://download.lighttpd.net/lighttpd/releases-$(LIGHTTPD_VERSION_MAJOR).x
LIGHTTPD_LICENSE = BSD-3-Clause
LIGHTTPD_LICENSE_FILES = COPYING
LIGHTTPD_DEPENDENCIES = host-pkgconf
LIGHTTPD_CONF_OPTS = \
	--without-wolfssl \
	--libdir=/usr/lib/lighttpd \
	--libexecdir=/usr/lib

ifeq ($(BR2_PACKAGE_LIGHTTPD_OPENSSL),y)
LIGHTTPD_DEPENDENCIES += openssl
LIGHTTPD_CONF_OPTS += --with-openssl
else
LIGHTTPD_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_PAM),y)
LIGHTTPD_DEPENDENCIES += linux-pam
LIGHTTPD_CONF_OPTS += --with-pam
else
LIGHTTPD_CONF_OPTS += --without-pam
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_ZLIB),y)
LIGHTTPD_DEPENDENCIES += zlib
LIGHTTPD_CONF_OPTS += --with-zlib
else
LIGHTTPD_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_BZIP2),y)
LIGHTTPD_DEPENDENCIES += bzip2
LIGHTTPD_CONF_OPTS += --with-bzip2
else
LIGHTTPD_CONF_OPTS += --without-bzip2
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_PCRE),y)
LIGHTTPD_CONF_ENV = PCRECONFIG=$(STAGING_DIR)/usr/bin/pcre-config
LIGHTTPD_DEPENDENCIES += pcre
LIGHTTPD_CONF_OPTS += --with-pcre
else
LIGHTTPD_CONF_OPTS += --without-pcre
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_WEBDAV),y)
LIGHTTPD_DEPENDENCIES += libxml2 sqlite
LIGHTTPD_CONF_OPTS += --with-webdav-props
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
LIGHTTPD_CONF_OPTS += --with-webdav-locks
LIGHTTPD_DEPENDENCIES += util-linux
else
LIGHTTPD_CONF_OPTS += --without-webdav-locks
endif
else
LIGHTTPD_CONF_OPTS += --without-webdav-props --without-webdav-locks
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_LUA),y)
LIGHTTPD_DEPENDENCIES += lua
LIGHTTPD_CONF_OPTS += --with-lua
else
LIGHTTPD_CONF_OPTS += --without-lua
endif

define LIGHTTPD_INSTALL_CONFIG
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/lighttpd/conf.d
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/www
	$(INSTALL) -D -m 0644 $(@D)/doc/config/lighttpd.conf \
		$(TARGET_DIR)/etc/lighttpd/lighttpd.conf
	$(INSTALL) -D -m 0644 $(@D)/doc/config/modules.conf \
		$(TARGET_DIR)/etc/lighttpd/modules.conf
	$(INSTALL) -D -m 0644 $(@D)/doc/config/conf.d/access_log.conf \
		$(TARGET_DIR)/etc/lighttpd/conf.d/access_log.conf
	$(INSTALL) -D -m 0644 $(@D)/doc/config/conf.d/debug.conf \
		$(TARGET_DIR)/etc/lighttpd/conf.d/debug.conf
	$(INSTALL) -D -m 0644 $(@D)/doc/config/conf.d/dirlisting.conf \
		$(TARGET_DIR)/etc/lighttpd/conf.d/dirlisting.conf
	$(INSTALL) -D -m 0644 $(@D)/doc/config/conf.d/mime.conf \
		$(TARGET_DIR)/etc/lighttpd/conf.d/mime.conf
endef

LIGHTTPD_POST_INSTALL_TARGET_HOOKS += LIGHTTPD_INSTALL_CONFIG

define LIGHTTPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/lighttpd/S50lighttpd \
		$(TARGET_DIR)/etc/init.d/S50lighttpd
endef

define LIGHTTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/doc/systemd/lighttpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/lighttpd.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/lighttpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/lighttpd.service

	$(INSTALL) -D -m 644 package/lighttpd/lighttpd_tmpfiles.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/lighttpd.conf
endef

$(eval $(autotools-package))
