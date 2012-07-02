#############################################################
#
# olsr
#
#############################################################

OLSR_VERSION_MAJOR=0.5
OLSR_VERSION_MINOR=6
OLSR_VERSION:=$(OLSR_VERSION_MAJOR).$(OLSR_VERSION_MINOR)
OLSR_SOURCE:=olsrd-$(OLSR_VERSION).tar.bz2
OLSR_SITE:=http://www.olsr.org/releases/$(OLSR_VERSION_MAJOR)
OLSR_BINARY:=olsrd
OLSR_TARGET_BINARY:=usr/sbin/olsrd
#OLSR_PLUGINS=httpinfo tas dot_draw nameservice dyn_gw dyn_gw_plain pgraph bmf quagga secure
OLSR_PLUGINS=dot_draw dyn_gw secure
OLSR_TARGET_PLUGIN=usr/lib/

define OLSR_BUILD_CMDS
 $(TARGET_CONFIGURE_OPTS) $(MAKE) ARCH=$(KERNEL_ARCH) -C $(@D) olsrd $(OLSR_PLUGINS)
endef

define OLSR_INSTALL_TARGET_CMDS
 cp -dpf $(@D)/$(OLSR_BINARY) $(TARGET_DIR)/$(OLSR_TARGET_BINARY)
 cp -R $(@D)/lib/*/olsrd_*.so* $(TARGET_DIR)/$(OLSR_TARGET_PLUGIN)
 mkdir -p $(TARGET_DIR)/etc/init.d
 cp -dpf package/olsr/S50olsr $(TARGET_DIR)/etc/init.d/
 test -r $(TARGET_DIR)/etc/olsrd.conf || \
   cp -dpf $(@D)/files/olsrd.conf.default.lq $(TARGET_DIR)/etc/olsrd.conf
 -$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(OLSR_TARGET_PLUGIN)/olsrd_*.so*
 $(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/$(OLSR_TARGET_BINARY)
endef

define OLSR_CLEAN_CMDS
	rm -f $(TARGET_DIR)/$(OLSR_TARGET_BINARY) \
		$(TARGET_DIR)/$(OLSR_TARGET_PLUGIN)/olsrd_*.so* \
		$(TARGET_DIR)/etc/init.d/S50olsr \
		$(TARGET_DIR)/etc/olsrd.conf
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
