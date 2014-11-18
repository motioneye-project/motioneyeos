################################################################################
#
# rapidjson
#
################################################################################

RAPIDJSON_VERSION = 39f5eeb764c6d1e1cbff1717410d9710bf943009
RAPIDJSON_SITE = $(call github,miloyip,rapidjson,$(RAPIDJSON_VERSION))
RAPIDJSON_LICENSE = MIT
RAPIDJSON_LICENSE_FILES = license.txt
RAPIDJSON_INSTALL_TARGET = NO
RAPIDJSON_INSTALL_STAGING = YES

define RAPIDJSON_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/rapidjson
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/rapidjson/internal
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/rapidjson/error
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/include/rapidjson/msinttypes
	$(INSTALL) -m 0644 $(@D)/include/rapidjson/*.h \
		$(STAGING_DIR)/usr/include/rapidjson
	$(INSTALL) -m 0644 $(@D)/include/rapidjson/internal/*.h \
		$(STAGING_DIR)/usr/include/rapidjson/internal
	$(INSTALL) -m 0644 $(@D)/include/rapidjson/error/*.h \
		$(STAGING_DIR)/usr/include/rapidjson/error
	$(INSTALL) -m 0644 $(@D)/include/rapidjson/msinttypes/*.h \
		$(STAGING_DIR)/usr/include/rapidjson/msinttypes
endef

$(eval $(generic-package))
