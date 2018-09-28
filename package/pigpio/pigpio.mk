################################################################################
#
# pigpio
#
################################################################################

PIGPIO_VERSION = V67
PIGPIO_SITE = $(call github,joan2937,pigpio,$(PIGPIO_VERSION))
PIGPIO_LICENSE = Unlicense
PIGPIO_LICENSE_FILES = UNLICENCE

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

$(eval $(generic-package))
