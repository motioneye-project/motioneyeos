################################################################################
#
# rapidjson
#
################################################################################

RAPIDJSON_VERSION = v1.1.0
RAPIDJSON_SITE = $(call github,miloyip,rapidjson,$(RAPIDJSON_VERSION))
RAPIDJSON_LICENSE = MIT
RAPIDJSON_LICENSE_FILES = license.txt

# rapidjson is a header-only C++ library
RAPIDJSON_INSTALL_TARGET = NO
RAPIDJSON_INSTALL_STAGING = YES

define RAPIDJSON_INSTALL_STAGING_CMDS
	cp -dpfr $(@D)/include/* $(STAGING_DIR)/usr/include
endef

$(eval $(generic-package))
