################################################################################
#
# rsyslog
#
################################################################################

RSYSLOG_VERSION = 5.8.0
RSYSLOG_SITE = http://rsyslog.com/files/download/rsyslog/
RSYSLOG_DEPENDENCIES = zlib

# Build after Busybox
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	RSYSLOG_DEPENDENCIES += busybox
endif

define RSYSLOG_INSTALL_CONF_SCRIPT
	[ -f $(TARGET_DIR)/etc/init.d/S01rsyslog ] || \
		$(INSTALL) -m 0755 -D package/rsyslog/S01rsyslog \
			$(TARGET_DIR)/etc/init.d/S01rsyslog
	[ -f $(TARGET_DIR)/etc/rsyslog.conf ] || \
		$(INSTALL) -m 0644 -D $(@D)/rsyslog.conf \
			$(TARGET_DIR)/etc/rsyslog.conf
	mkdir -p $(TARGET_DIR)/etc/rsyslog.d
endef

RSYSLOG_POST_INSTALL_TARGET_HOOKS += RSYSLOG_INSTALL_CONF_SCRIPT

$(eval $(autotools-package))
