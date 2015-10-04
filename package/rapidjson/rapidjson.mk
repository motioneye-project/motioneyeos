################################################################################
#
# rapidjson
#
################################################################################

RAPIDJSON_VERSION = v1.0.2
RAPIDJSON_SITE = $(call github,miloyip,rapidjson,$(RAPIDJSON_VERSION))
RAPIDJSON_LICENSE = MIT
RAPIDJSON_LICENSE_FILES = license.txt
RAPIDJSON_INSTALL_TARGET = NO
RAPIDJSON_INSTALL_STAGING = YES

define RAPIDJSON_INSTALL_STAGING_CMDS
	cp -dpfr $(@D)/include/* $(STAGING_DIR)/usr/include
endef

$(eval $(generic-package))
