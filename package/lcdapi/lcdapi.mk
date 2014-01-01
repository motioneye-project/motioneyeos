################################################################################
#
# lcdapi
#
################################################################################

LCDAPI_VERSION = v0.4
LCDAPI_SITE = $(call github,spdawson,lcdapi,$(LCDAPI_VERSION))
LCDAPI_LICENSE = LGPLv2.1+
LCDAPI_LICENSE_FILES = COPYING

LCDAPI_INSTALL_STAGING = YES

define LCDAPI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define LCDAPI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR="$(STAGING_DIR)" install
endef

define LCDAPI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
