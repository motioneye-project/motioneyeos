#############################################################
#
# lm-sensors
#
#############################################################
LM_SENSORS_VERSION:=3.0.2
LM_SENSORS_SOURCE:=lm_sensors-$(LM_SENSORS_VERSION).tar.bz2
LM_SENSORS_SITE:=http://dl.lm-sensors.org/lm-sensors/releases
LM_SENSORS_DIR:=$(BUILD_DIR)/lm_sensors-$(LM_SENSORS_VERSION)
LM_SENSORS_CAT:=$(BZCAT)
LM_SENSORS_BINARY:=prog/sensors/sensors
LM_SENSORS_TARGET_BINARY:=usr/bin/sensors

$(DL_DIR)/$(LM_SENSORS_SOURCE):
	$(WGET) -P $(DL_DIR) $(LM_SENSORS_SITE)/$(LM_SENSORS_SOURCE)

$(LM_SENSORS_DIR)/.unpacked: $(DL_DIR)/$(LM_SENSORS_SOURCE)
	$(LM_SENSORS_CAT) $(DL_DIR)/$(LM_SENSORS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LM_SENSORS_DIR) package/lm-sensors/ lm-sensors\*.patch
	touch $@

$(LM_SENSORS_DIR)/$(LM_SENSORS_BINARY): $(LM_SENSORS_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) MACHINE=$(KERNEL_ARCH)\
		-C $(LM_SENSORS_DIR)

$(TARGET_DIR)/$(LM_SENSORS_TARGET_BINARY): $(LM_SENSORS_DIR)/$(LM_SENSORS_BINARY)
	if [ ! -f $(TARGET_DIR)/etc/sensors.conf ]; then \
		cp -dpf $(LM_SENSORS_DIR)/etc/sensors.conf.eg \
			$(TARGET_DIR)/etc/sensors.conf; \
		$(SED) '/^#/d' -e '/^[[:space:]]*$$/d' \
			$(TARGET_DIR)/etc/sensors.conf; \
	fi
	cp -dpf $(LM_SENSORS_DIR)/$(LM_SENSORS_BINARY) $@
	cp -dpf $(LM_SENSORS_DIR)/lib/libsensors.so* \
		$(LM_SENSORS_DIR)/lib/libsensors.a $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/lib/libsensors.so*
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@

lm-sensors-source: $(DL_DIR)/$(LM_SENSORS_SOURCE) $(LM_SENSORS_PATCH_FILE)

lm-sensors-unpacked: $(LM_SENSORS_DIR)/.unpacked

lm-sensors: uclibc $(TARGET_DIR)/$(LM_SENSORS_TARGET_BINARY)

lm-sensors-clean:
	-$(MAKE) -C $(LM_SENSORS_DIR) clean
	rm -f $(TARGET_DIR)/$(LM_SENSORS_TARGET_BINARY) \
		$(TARGET_DIR)/usr/lib/libsensors* \
		$(TARGET_DIR)/etc/sensors.conf

lm-sensors-dirclean:
	rm -rf $(LM_SENSORS_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LM_SENSORS)),y)
TARGETS+=lm-sensors
endif
