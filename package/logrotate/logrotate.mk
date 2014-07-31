################################################################################
#
# logrotate
#
################################################################################

LOGROTATE_VERSION = 3.8.7
LOGROTATE_SITE = https://www.fedorahosted.org/releases/l/o/logrotate
LOGROTATE_LICENSE = GPLv2+
LOGROTATE_LICENSE_FILES = COPYING

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

$(eval $(generic-package))
