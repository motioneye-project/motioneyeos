#############################################################
#
# i2c-tools
#
#############################################################
I2C_TOOLS_VERSION:=3.0.1
I2C_TOOLS_SOURCE:=i2c-tools-$(I2C_TOOLS_VERSION).tar.bz2
I2C_TOOLS_SITE:=http://dl.lm-sensors.org/i2c-tools/releases/
I2C_TOOLS_AUTORECONF = NO
I2C_TOOLS_INSTALL_STAGING = YES
I2C_TOOLS_CONF_ENV =
I2C_TOOLS_CONF_OPT =
I2C_TOOLS_MAKE_OPT = $(TARGET_CONFIGURE_OPTS)
I2C_TOOLS_DEPENDENCIES =

$(eval $(call AUTOTARGETS,package,i2c-tools))

$(I2C_TOOLS_TARGET_CONFIGURE):
	touch $@

$(I2C_TOOLS_TARGET_INSTALL_TARGET):
	for i in i2cdump i2cget i2cset i2cdetect; \
	do \
		$(INSTALL) -m 755 $(I2C_TOOLS_DIR)/tools/$$i $(TARGET_DIR)/usr/bin; \
		$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/$$i; \
	done
	touch $@
