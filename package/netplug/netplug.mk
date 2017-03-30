################################################################################
#
# netplug
#
################################################################################

NETPLUG_VERSION = 1.2.9.2
NETPLUG_SOURCE = netplug-$(NETPLUG_VERSION).tar.bz2
NETPLUG_SITE = http://www.red-bean.com/~bos/netplug
NETPLUG_LICENSE = GPL-2.0
NETPLUG_LICENSE_FILES = COPYING

define NETPLUG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NETPLUG_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

define NETPLUG_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/netplug/S29netplug \
		$(TARGET_DIR)/etc/init.d/S29netplug
endef

define NETPLUG_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/netplug/netplug.service \
		$(TARGET_DIR)/usr/lib/systemd/system/netplug.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/netplug.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/netplug.service
endef

$(eval $(generic-package))
