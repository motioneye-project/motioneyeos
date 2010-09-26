#############################################################
#
# lm-sensors
#
#############################################################
LM_SENSORS_VERSION = 3.1.2
LM_SENSORS_SOURCE = lm_sensors-$(LM_SENSORS_VERSION).tar.bz2
LM_SENSORS_SITE = http://dl.lm-sensors.org/lm-sensors/releases
LM_SENSORS_TARGET_BINARY = usr/bin/sensors

define LM_SENSORS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) MACHINE=$(KERNEL_ARCH) -C $(@D)
endef

define LM_SENSORS_INSTALL_TARGET_CMDS
	if [ ! -f $(TARGET_DIR)/etc/sensors.conf ]; then \
		cp -dpf $(@D)/etc/sensors.conf.eg $(TARGET_DIR)/etc/sensors.conf; \
		$(SED) '/^#/d' -e '/^[[:space:]]*$$/d' $(TARGET_DIR)/etc/sensors.conf; \
	fi
	cp -dpf $(@D)/prog/sensors/sensors $(TARGET_DIR)/$(LM_SENSORS_TARGET_BINARY)
	cp -dpf $(@D)/lib/libsensors.so* \
		$(@D)/lib/libsensors.a $(TARGET_DIR)/usr/lib/
endef

define LM_SENSORS_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
	rm -f $(TARGET_DIR)/$(LM_SENSORS_TARGET_BINARY) \
		$(TARGET_DIR)/usr/lib/libsensors* \
		$(TARGET_DIR)/etc/sensors.conf
endef

$(eval $(call GENTARGETS,package,lm-sensors))
