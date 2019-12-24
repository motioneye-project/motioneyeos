################################################################################
#
# dante
#
################################################################################

DANTE_VERSION = 1.4.2
DANTE_SITE = http://www.inet.no/dante/files
DANTE_LICENSE = BSD-3-Clause
DANTE_LICENSE_FILES = LICENSE

# Needed so that our libtool patch applies properly
DANTE_AUTORECONF = YES

DANTE_CONF_OPTS += --disable-client --disable-preload

ifeq ($(BR2_PACKAGE_LIBMINIUPNPC),y)
DANTE_DEPENDENCIES += libminiupnpc
DANTE_CONF_OPTS += --with-upnp
else
DANTE_CONF_OPTS += --without-upnp
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
DANTE_DEPENDENCIES += linux-pam
DANTE_CONF_OPTS += --with-pam
else
DANTE_CONF_OPTS += --without-pam
endif

define DANTE_INSTALL_CONFIG_FILE
	$(INSTALL) -D -m 644 $(@D)/example/sockd.conf \
		$(TARGET_DIR)/etc/sockd.conf
endef

DANTE_POST_INSTALL_TARGET_HOOKS += DANTE_INSTALL_CONFIG_FILE

define DANTE_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/dante/dante.service \
		$(TARGET_DIR)/usr/lib/systemd/system/dante.service
endef

define DANTE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/dante/S50dante \
		$(TARGET_DIR)/etc/init.d/S50dante
endef

$(eval $(autotools-package))
