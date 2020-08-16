################################################################################
#
# bandwidthd
#
################################################################################

BANDWIDTHD_VERSION = 2.0.1-auto-r11
BANDWIDTHD_SITE = $(call github,nroach44,bandwidthd,v$(BANDWIDTHD_VERSION))

# Specified as "any version of the GPL that is current as of your
# download" by upstream.
BANDWIDTHD_LICENSE = GPL

BANDWIDTHD_DEPENDENCIES = gd libpng libpcap host-pkgconf

BANDWIDTHD_AUTORECONF = YES

BANDWIDTHD_CONF_OPTS += --with-pcap-config=$(STAGING_DIR)/usr/bin/pcap-config

ifeq ($(BR2_PACKAGE_BANDWIDTHD_POSTGRESQL),y)
BANDWIDTHD_DEPENDENCIES += postgresql
BANDWIDTHD_CONF_OPTS += --with-postgresql-logging=true
else
BANDWIDTHD_CONF_OPTS += --with-postgresql-logging=false
endif

ifeq ($(BR2_PACKAGE_BANDWIDTHD_SQLITE3),y)
BANDWIDTHD_DEPENDENCIES += sqlite
BANDWIDTHD_CONF_OPTS += --with-sqlite-storage=true
else
BANDWIDTHD_CONF_OPTS += --with-sqlite-storage=false
endif

define BANDWIDTHD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/bandwidthd/bandwidthd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/bandwidthd.service
endef

$(eval $(autotools-package))
