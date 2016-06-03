################################################################################
#
# wiringpi
#
################################################################################

# original site is down (2016-06-03)
#
# WIRINGPI_VERSION = 2.31
# WIRINGPI_SITE = git://git.drogon.net/wiringPi
#
# so change to alternative location (verifyed that commit 78b5c323
# has the same content as local copy of wiringpi-2.31.tar.gz)
#
WIRINGPI_VERSION = 78b5c323b74de782df58ee558c249e4e4fadd25f
WIRINGPI_SITE = $(call github,WiringPi,WiringPi,$(WIRINGPI_VERSION))

WIRINGPI_LICENSE = LGPLv3+
WIRINGPI_LICENSE_FILES = COPYING.LESSER
WIRINGPI_INSTALL_STAGING = YES

ifeq ($(BR2_STATIC_LIBS),y)
WIRINGPI_LIB_BUILD_TARGETS = static
WIRINGPI_LIB_INSTALL_TARGETS = install-static
WIRINGPI_BIN_BUILD_TARGETS = gpio-static
else ifeq ($(BR2_SHARED_LIBS),y)
WIRINGPI_LIB_BUILD_TARGETS = all
WIRINGPI_LIB_INSTALL_TARGETS = install
WIRINGPI_BIN_BUILD_TARGETS = all
else
WIRINGPI_LIB_BUILD_TARGETS = all static
WIRINGPI_LIB_INSTALL_TARGETS = install install-static
WIRINGPI_BIN_BUILD_TARGETS = all
endif

define WIRINGPI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/wiringPi $(WIRINGPI_LIB_BUILD_TARGETS)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/devLib $(WIRINGPI_LIB_BUILD_TARGETS)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/gpio $(WIRINGPI_BIN_BUILD_TARGETS)
endef

define WIRINGPI_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/wiringPi $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(STAGING_DIR) PREFIX=/usr LDCONFIG=true
	$(MAKE) -C $(@D)/devLib $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(STAGING_DIR) PREFIX=/usr LDCONFIG=true
endef

define WIRINGPI_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/wiringPi $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(TARGET_DIR) PREFIX=/usr LDCONFIG=true
	$(MAKE) -C $(@D)/devLib $(WIRINGPI_LIB_INSTALL_TARGETS) DESTDIR=$(TARGET_DIR) PREFIX=/usr LDCONFIG=true
	$(INSTALL) -D -m 0755 $(@D)/gpio/gpio $(TARGET_DIR)/usr/bin/gpio
	$(INSTALL) -D -m 0755 $(@D)/gpio/pintest $(TARGET_DIR)/usr/bin/pintest
endef

$(eval $(generic-package))
