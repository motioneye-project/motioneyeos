################################################################################
#
# netplug
#
################################################################################

NETPLUG_VERSION = 1.2.9.2
NETPLUG_SOURCE = netplug-$(NETPLUG_VERSION).tar.bz2
NETPLUG_SITE = http://www.red-bean.com/~bos/netplug

define NETPLUG_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NETPLUG_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

define NETPLUG_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/netplug/S29netplug \
		$(TARGET_DIR)/etc/init.d/S29netplug
endef

define NETPLUG_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/netplugd
	rm -rf $(TARGET_DIR)/etc/netplug*
	rm -f $(TARGET_DIR)/etc/init.d/S29netplug
endef

define NETPLUG_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
