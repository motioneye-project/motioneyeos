################################################################################
#
# rsyslog
#
################################################################################

RSYSLOG_VERSION = 7.6.0
RSYSLOG_SITE = http://rsyslog.com/files/download/rsyslog
RSYSLOG_LICENSE = GPLv3 LGPLv3 Apache-2.0
RSYSLOG_LICENSE_FILES = COPYING COPYING.LESSER COPYING.ASL20
RSYSLOG_DEPENDENCIES = zlib libestr liblogging json-c util-linux host-pkgconf
RSYSLOG_AUTORECONF = YES

RSYSLOG_CONF_OPT = --disable-testbench \
		   --enable-cached-man-pages

# Build after BusyBox
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	RSYSLOG_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_LIBEE),y)
	RSYSLOG_DEPENDENCIES += libee
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
	RSYSLOG_DEPENDENCIES += libgcrypt
	RSYSLOG_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
	RSYSLOG_CONF_OPT += --enable-libgcrypt=yes
else
	RSYSLOG_CONF_OPT += --enable-libgcrypt=no
endif

define RSYSLOG_INSTALL_INIT_SYSV
	[ -f $(TARGET_DIR)/etc/init.d/S01rsyslog ] || \
		$(INSTALL) -m 0755 -D package/rsyslog/S01rsyslog \
			$(TARGET_DIR)/etc/init.d/S01rsyslog
endef

define RSYSLOG_INSTALL_CONF_SCRIPT
	[ -f $(TARGET_DIR)/etc/rsyslog.conf ] || \
		$(INSTALL) -m 0644 -D $(@D)/platform/redhat/rsyslog.conf \
			$(TARGET_DIR)/etc/rsyslog.conf
	mkdir -p $(TARGET_DIR)/etc/rsyslog.d
endef

RSYSLOG_POST_INSTALL_TARGET_HOOKS += RSYSLOG_INSTALL_CONF_SCRIPT

$(eval $(autotools-package))
