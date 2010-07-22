#############################################################
#
# wireless_tools
#
#############################################################

WIRELESS_TOOLS_VERSION = 29
WIRELESS_TOOLS_SITE = http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux
WIRELESS_TOOLS_SOURCE = wireless_tools.$(WIRELESS_TOOLS_VERSION).tar.gz

define WIRELESS_TOOLS_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		iwmulticall
endef

define WIRELESS_TOOLS_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
	rm -f $(@D)/iwmulticall
endef

define WIRELESS_TOOLS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX="$(TARGET_DIR)" install-iwmulticall
	$(MAKE) -C $(@D) INSTALL_MAN="$(TARGET_DIR)/usr/share/man" install-man
endef

define WIRELESS_TOOLS_UNINSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX="$(TARGET_DIR)" uninstall
endef

$(eval $(call GENTARGETS,package,wireless_tools))
