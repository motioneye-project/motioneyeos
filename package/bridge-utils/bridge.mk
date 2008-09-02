#############################################################
#
# bridge-utils - User Space Program For Controlling Bridging
#
#############################################################
#
BRIDGE_VERSION:=1.0.6
BRIDGE_SOURCE:=bridge-utils-$(BRIDGE_VERSION).tar.gz
BRIDGE_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/bridge/
BRIDGE_INSTALL_STAGING:=NO
BRIDGE_INSTALL_TARGET:=YES
BRIDGE_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install
BRIDGE_CONF_OPT:=--with-linux-headers=$(LINUX_HEADERS_DIR) $(DISABLE_NLS)
BRIDGE_DEPENDENCIES:=uclibc

$(eval $(call AUTOTARGETS,package,bridge))

# bridge has no install-strip target
$(BRIDGE_HOOK_POST_INSTALL): $(BRIDGE_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/sbin/brctl
	touch $@

# bridge has no uninstall target
$(BUILD_DIR)/bridge-$(BRIDGE_VERSION)/.stamp_cleaned:
	$(call MESSAGE,"Cleaning up")
	rm -f $(addprefix $(TARGET_DIR)/usr/,lib/libbridge.a \
		include/libbridge.h man/man8/brctl.8 sbin/brctl)
	touch $@
