#############################################################
#
# fbset
#
#############################################################
FBSET_VERSION = 2.1
FBSET_SOURCE = fbset-$(FBSET_VERSION).tar.gz
FBSET_SITE = http://users.telenet.be/geertu/Linux/fbdev
FBSET_BINARY = fbset
FBSET_TARGET_BINARY = usr/sbin/$(FBSET_BINARY)

define FBSET_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FBSET_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/$(FBSET_BINARY) $(TARGET_DIR)/$(FBSET_TARGET_BINARY)
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(FBSET_TARGET_BINARY)
endef

define FBSET_CLEAN_CMDS
	rm -f $(TARGET_DIR)/$(FBSET_TARGET_BINARY)
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS,package,fbset))
