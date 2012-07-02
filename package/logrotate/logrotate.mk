#############################################################
#
# logrotate
#
#############################################################
LOGROTATE_VERSION = 3.7.9
LOGROTATE_SOURCE = logrotate-$(LOGROTATE_VERSION).tar.gz
LOGROTATE_SITE = https://fedorahosted.org/releases/l/o/logrotate/

LOGROTATE_DEPENDENCIES = popt

define LOGROTATE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS)" LDFLAGS="$(LDFLAGS)" -C $(@D)
endef

define LOGROTATE_INSTALL_TARGET_CMDS
	$(MAKE) PREFIX=$(TARGET_DIR) -C $(@D) install
	if [ ! -f $(TARGET_DIR)/etc/logrotate.conf ]; then \
		$(INSTALL) -m 0644 package/logrotate/logrotate.conf $(TARGET_DIR)/etc/logrotate.conf; \
	fi
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/logrotate.d
endef

define LOGROTATE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/logrotate
	rm -f $(TARGET_DIR)/etc/logrotate.conf
	rm -f $(TARGET_DIR)/usr/man/man5/logrotate.conf.5
	rm -f $(TARGET_DIR)/usr/man/man8/logrotate.8
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/etc/logrotate.d
endef

define LOGROTATE_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
