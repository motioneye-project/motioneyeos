################################################################################
#
# netifrc
#
################################################################################

NETIFRC_VERSION = 0.6.1
NETIFRC_SITE = $(call github,gentoo,netifrc,$(NETIFRC_VERSION))
NETIFRC_LICENSE = BSD-2-Clause
NETIFRC_LICENSE_FILES = LICENSE

NETIFRC_DEPENDENCIES = openrc

# set LIBNAME so netifrc puts files in proper directories and sets proper
# paths in installed files. Since in buildroot /lib64 and /lib32 always
# points to /lib, it's safe to hardcode it to "lib"
NETIFRC_MAKE_OPTS = \
	LIBNAME=lib \
	UDEVDIR=/lib/udev \
	LIBEXECDIR=/usr/libexec/netifrc

define NETIFRC_BUILD_CMDS
	$(MAKE) $(NETIFRC_MAKE_OPTS) -C $(@D)
endef

ifeq ($(BR2_PACKAGE_HAS_UDEV),)
define NETIFRC_REMOVE_UDEV
	$(RM) $(TARGET_DIR)/lib/udev/net.sh
	$(RM) $(TARGET_DIR)/lib/udev/rules.d/90-network.rules
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/lib/udev/rules.d
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/lib/udev
endef
endif # BR2_PACKAGE_HAS_UDEV

NETIFRC_DHCP_IFACE = $(call qstrip,$(BR2_SYSTEM_DHCP))
ifneq ($(NETIFRC_DHCP_IFACE),)
NETIFRC_DHCP_CFG = config_$(NETIFRC_DHCP_IFACE)="dhcp"
define NETIFRC_DHCP_SERVICE
	ln -sf net.lo $(TARGET_DIR)/etc/init.d/net.$(NETIFRC_DHCP_IFACE)
	ln -sf /etc/init.d/net.$(NETIFRC_DHCP_IFACE) \
		$(TARGET_DIR)/etc/runlevels/default/net.$(NETIFRC_DHCP_IFACE)
endef
endif # BR2_SYSTEM_DHCP != ""

define NETIFRC_NET_CFG
	config_lo="127.0.0.1/8"
	$(NETIFRC_DHCP_CFG)
endef

define NETIFRC_INSTALL_TARGET_CMDS
	$(MAKE) $(NETIFRC_MAKE_OPTS) DESTDIR=$(TARGET_DIR) -C $(@D) install
	$(NETIFRC_REMOVE_UDEV)
	$(call PRINTF,$(NETIFRC_NET_CFG)) > $(TARGET_DIR)/etc/conf.d/net
	ln -sf /etc/init.d/net.lo $(TARGET_DIR)/etc/runlevels/default/net.lo
	$(NETIFRC_DHCP_SERVICE)
endef

$(eval $(generic-package))
