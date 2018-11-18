################################################################################
#
# wiringpi
#
################################################################################

WIRINGPI_VERSION = 2.46
WIRINGPI_SITE = git://git.drogon.net/wiringPi

WIRINGPI_LICENSE = LGPL-3.0+
WIRINGPI_LICENSE_FILES = COPYING.LESSER
WIRINGPI_INSTALL_STAGING = YES

define WIRINGPI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/wiringPi all
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/devLib all
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/gpio all
endef

define WIRINGPI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/wiringPi install DESTDIR=$(STAGING_DIR) PREFIX=/usr LDCONFIG=true
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/devLib install DESTDIR=$(STAGING_DIR) PREFIX=/usr LDCONFIG=true
endef

define WIRINGPI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/wiringPi install DESTDIR=$(TARGET_DIR) PREFIX=/usr LDCONFIG=true
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/devLib install DESTDIR=$(TARGET_DIR) PREFIX=/usr LDCONFIG=true
	$(INSTALL) -D -m 0755 $(@D)/gpio/gpio $(TARGET_DIR)/usr/bin/gpio
	$(INSTALL) -D -m 0755 $(@D)/gpio/pintest $(TARGET_DIR)/usr/bin/pintest
endef

$(eval $(generic-package))
