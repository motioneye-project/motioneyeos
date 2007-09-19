#############################################################
#
# olsr
#
#############################################################

OLSR_VERSION_MAJOR=0.5
OLSR_VERSION_MINOR=3
OLSR_VERSION:=$(OLSR_VERSION_MAJOR).$(OLSR_VERSION_MINOR)
OLSR_SOURCE:=olsrd-$(OLSR_VERSION).tar.bz2
OLSR_SITE:=http://www.olsr.org/releases/$(OLSR_VERSION_MAJOR)
OLSR_DIR:=$(BUILD_DIR)/olsrd-$(OLSR_VERSION)
OLSR_CAT:=$(BZCAT)
OLSR_BINARY:=olsrd
OLSR_TARGET_BINARY:=usr/bin/olsrd
#OLSR_PLUGINS=httpinfo tas dot_draw nameservice dyn_gw dyn_gw_plain pgraph bmf quagga secure
OLSR_PLUGINS=dot_draw dyn_gw secure
OLSR_TARGET_PLUGIN=usr/lib/

$(DL_DIR)/$(OLSR_SOURCE):
	$(WGET) -P $(DL_DIR) $(OLSR_SITE)/$(OLSR_SOURCE)

olsr-source: $(DL_DIR)/$(OLSR_SOURCE)

olsr-unpacked: $(OLSR_DIR)/.unpacked
$(OLSR_DIR)/.unpacked: $(DL_DIR)/$(OLSR_SOURCE)
	$(OLSR_CAT) $(DL_DIR)/$(OLSR_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(OLSR_DIR)/$(OLSR_BINARY): $(OLSR_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(OLSR_DIR) olsrd $(OLSR_PLUGINS)

$(TARGET_DIR)/$(OLSR_TARGET_BINARY): $(OLSR_DIR)/$(OLSR_BINARY)
	rm -f $(TARGET_DIR)/$(OLSR_TARGET_BINARY)
	cp -dpf $(OLSR_DIR)/$(OLSR_BINARY) $(TARGET_DIR)/$(OLSR_TARGET_BINARY)
	cp -R $(OLSR_DIR)/lib/*/olsrd_*.so* $(TARGET_DIR)/$(OLSR_TARGET_PLUGIN)
	mkdir -p $(TARGET_DIR)/etc/init.d
	cp -dpf package/olsr/S50olsr $(TARGET_DIR)/etc/init.d/
	test -r $(TARGET_DIR)/etc/olsrd.conf || \
		cp -dpf $(OLSR_DIR)/files/olsrd.conf.default.lq $(TARGET_DIR)/etc/olsrd.conf
	-$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(OLSR_TARGET_PLUGIN)/olsrd_*.so*
	$(STRIP) $(STRIP_STRIP_ALL) $@

olsr: uclibc $(TARGET_DIR)/$(OLSR_TARGET_BINARY)

olsr-clean:
	rm -f $(TARGET_DIR)/$(OLSR_TARGET_BINARY) \
		$(TARGET_DIR)/$(OLSR_TARGET_PLUGIN)/olsrd_*.so* \
		$(TARGET_DIR)/etc/init.d/S50olsr \
		$(TARGET_DIR)/etc/olsrd.conf
	-$(MAKE) -C $(OLSR_DIR) clean

olsr-dirclean:
	rm -rf $(OLSR_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_OLSR)),y)
TARGETS+=olsr $(OLSR_PLUGINS)
endif
