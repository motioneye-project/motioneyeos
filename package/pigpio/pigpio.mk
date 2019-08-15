################################################################################
#
# pigpio
#
################################################################################

PIGPIO_VERSION = 68
PIGPIO_SITE = $(call github,joan2937,pigpio,V$(PIGPIO_VERSION))
PIGPIO_LICENSE = Unlicense
PIGPIO_LICENSE_FILES = UNLICENCE
PIGPIO_INSTALL_STAGING = YES

define PIGPIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define PIGPIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/pig2vcd $(TARGET_DIR)/usr/bin/pig2vcd
	$(INSTALL) -D -m 0755 $(@D)/pigpiod $(TARGET_DIR)/usr/bin/pigpiod
	$(INSTALL) -D -m 0755 $(@D)/pigs $(TARGET_DIR)/usr/bin/pigs
	$(INSTALL) -D -m 0755 $(@D)/libpigpio.so $(TARGET_DIR)/usr/lib/libpigpio.so
	$(INSTALL) -D -m 0755 $(@D)/libpigpiod_if.so $(TARGET_DIR)/usr/lib/libpigpiod_if.so
	$(INSTALL) -D -m 0755 $(@D)/libpigpiod_if2.so $(TARGET_DIR)/usr/lib/libpigpiod_if2.so
endef

define PIGPIO_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libpigpio.so $(STAGING_DIR)/usr/lib/libpigpio.so
	$(INSTALL) -D -m 0755 $(@D)/libpigpiod_if.so $(STAGING_DIR)/usr/lib/libpigpiod_if.so
	$(INSTALL) -D -m 0755 $(@D)/libpigpiod_if2.so $(STAGING_DIR)/usr/lib/libpigpiod_if2.so
	$(INSTALL) -D -m 0644 $(@D)/pigpio.h $(STAGING_DIR)/usr/include/pigpio.h
	$(INSTALL) -D -m 0644 $(@D)/pigpiod_if.h $(STAGING_DIR)/usr/include/pigpiod_if.h
	$(INSTALL) -D -m 0644 $(@D)/pigpiod_if2.h $(STAGING_DIR)/usr/include/pigpiod_if2.h
endef

$(eval $(generic-package))
