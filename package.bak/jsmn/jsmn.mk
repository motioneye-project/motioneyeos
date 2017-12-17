################################################################################
#
# jsmn
#
################################################################################

JSMN_VERSION = 6021415cc75e7922d45b12935f56348b064d8a7f
JSMN_SITE = $(call github,zserge,jsmn,$(JSMN_VERSION))
JSMN_LICENSE = MIT
JSMN_LICENSE_FILES = LICENSE
# static library only
JSMN_INSTALL_STAGING = YES
JSMN_INSTALL_TARGET = NO

define JSMN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define JSMN_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libjsmn.a $(STAGING_DIR)/usr/lib/libjsmn.a
	$(INSTALL) -D -m 0644 $(@D)/jsmn.h $(STAGING_DIR)/usr/include/jsmn.h
endef

$(eval $(generic-package))
