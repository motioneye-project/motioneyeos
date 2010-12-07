#############################################################
#
# whetstone
#
#############################################################

WHETSTONE_VERSION = 1.2
WHETSTONE_SOURCE = whetstone.c
WHETSTONE_SITE = http://www.netlib.org/benchmark/

define WHETSTONE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) LDLIBS="-lm" -C $(@D) whetstone
endef

define WHETSTONE_CLEAN_CMDS
	rm -f $(@D)/whetstone
endef

define WHETSTONE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/whetstone $(TARGET_DIR)/usr/bin/whetstone
endef

define WHETSTONE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/whetstone
endef

$(eval $(call GENTARGETS,package,whetstone))

$(BUILD_DIR)/whetstone-$(WHETSTONE_VERSION)/.stamp_extracted:
	@$(call MESSAGE,"Extracting")
	$(Q)mkdir -p $(@D)
	$(Q)cp $(DL_DIR)/$($(PKG)_SOURCE) $(@D)/
	$(Q)touch $@
