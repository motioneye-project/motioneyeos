################################################################################
#
# logrotate
#
################################################################################

LOGROTATE_VERSION = 3.8.7
LOGROTATE_SITE = https://www.fedorahosted.org/releases/l/o/logrotate
LOGROTATE_LICENSE = GPLv2+
LOGROTATE_LICENSE_FILES = COPYING

LOGROTATE_DEPENDENCIES = popt host-pkgconf

define LOGROTATE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC) $(TARGET_CFLAGS)" LDFLAGS="$(LDFLAGS)" \
		LOADLIBES="$(shell $(PKG_CONFIG_HOST_BINARY) --libs popt)" \
		-C $(@D)
endef

define LOGROTATE_INSTALL_TARGET_CMDS
	$(MAKE) PREFIX=$(TARGET_DIR) -C $(@D) install
	$(INSTALL) -m 0644 package/logrotate/logrotate.conf $(TARGET_DIR)/etc/logrotate.conf
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/logrotate.d
endef

$(eval $(generic-package))
