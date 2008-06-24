#############################################################
#
# i2c-tools
#
#############################################################
I2C_TOOLS_VERSION:=3.0.1
I2C_TOOLS_SOURCE:=i2c-tools-$(I2C_TOOLS_VERSION).tar.bz2
I2C_TOOLS_SITE:=http://dl.lm-sensors.org/i2c-tools/releases/
I2C_TOOLS_DIR:=$(BUILD_DIR)/i2c-tools-$(I2C_TOOLS_VERSION)
I2C_TOOLS_BINARY:=tools/i2cdetect
I2C_TOOLS_TARGET_BINARY:=usr/bin/i2cdetect

$(DL_DIR)/$(I2C_TOOLS_SOURCE):
	$(WGET) -P $(DL_DIR) $(I2C_TOOLS_SITE)/$(I2C_TOOLS_SOURCE)

$(I2C_TOOLS_DIR)/.unpacked: $(DL_DIR)/$(I2C_TOOLS_SOURCE)
	$(BZCAT) $(DL_DIR)/$(I2C_TOOLS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(I2C_TOOLS_DIR) package/i2c-tools/ i2c-tools-$(I2C_TOOLS_VERSION)\*.patch
	touch $@

$(I2C_TOOLS_DIR)/$(I2C_TOOLS_BINARY): $(I2C_TOOLS_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(I2C_TOOLS_DIR)

$(TARGET_DIR)/$(I2C_TOOLS_TARGET_BINARY): $(I2C_TOOLS_DIR)/$(I2C_TOOLS_BINARY)
	$(INSTALL) -m 755 -d $(@D)
	for i in i2cdump i2cget i2cset i2cdetect; \
	do \
		$(INSTALL) -m 755 $(<D)/$$i $(@D); \
		$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(@D)/$$i; \
	done

i2c-tools: uclibc $(TARGET_DIR)/$(I2C_TOOLS_TARGET_BINARY)

i2c-tools-source: $(DL_DIR)/$(I2C_TOOLS_SOURCE)

i2c-tools-clean:
	for i in i2cdump i2cget i2cset i2cdetect; \
	do \
		rm -f $(TARGET_DIR)/usr/bin/$$i; \
	done
	-$(MAKE) -C $(I2C_TOOLS_DIR) clean

i2c-tools-dirclean:
	rm -rf $(I2C_TOOLS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_I2C_TOOLS)),y)
TARGETS+=i2c-tools
endif
