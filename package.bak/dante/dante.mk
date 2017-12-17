################################################################################
#
# dante
#
################################################################################

DANTE_VERSION = 1.4.1
DANTE_SITE = http://www.inet.no/dante/files
DANTE_LICENSE = BSD-3c
DANTE_LICENSE_FILES = LICENSE

# Dante uses a *VERY* old configure.ac
DANTE_LIBTOOL_PATCH = NO

DANTE_CONF_OPTS += --disable-client --disable-preload

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
