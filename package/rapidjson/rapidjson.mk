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
	cp -dpfr $(@D)/include/* $(STAGING_DIR)/usr/include
endef

$(eval $(generic-package))
