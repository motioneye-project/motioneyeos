################################################################################
#
# rapidjson
#
################################################################################

RAPIDJSON_VERSION = 1.1.0
RAPIDJSON_SITE = $(call github,miloyip,rapidjson,v$(RAPIDJSON_VERSION))
RAPIDJSON_LICENSE = MIT
RAPIDJSON_LICENSE_FILES = license.txt

# rapidjson is a header-only C++ library
RAPIDJSON_INSTALL_TARGET = NO
RAPIDJSON_INSTALL_STAGING = YES

RAPIDJSON_CONF_OPTS = \
	-DRAPIDJSON_BUILD_DOC=OFF \
	-DRAPIDJSON_BUILD_EXAMPLES=OFF \
	-DRAPIDJSON_BUILD_TESTS=OFF

$(eval $(cmake-package))
