#############################################################
#
# bridge-utils - User Space Program For Controlling Bridging
#
#############################################################
#
BRIDGE_VERSION:=1.4
BRIDGE_SOURCE:=bridge-utils-$(BRIDGE_VERSION).tar.gz
BRIDGE_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/bridge/
BRIDGE_AUTORECONF:=YES
BRIDGE_INSTALL_STAGING:=NO
BRIDGE_INSTALL_TARGET:=YES
BRIDGE_CONF_OPT:=--with-linux-headers=$(LINUX_HEADERS_DIR)

define BRIDGE_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/,lib/libbridge.a \
		include/libbridge.h man/man8/brctl.8 sbin/brctl)
endef

$(eval $(call AUTOTARGETS,package,bridge))
