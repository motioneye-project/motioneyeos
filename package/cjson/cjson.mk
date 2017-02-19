################################################################################
#
# cjson
#
################################################################################

CJSON_VERSION = v1.3.0
CJSON_SITE = $(call github,DaveGamble,cjson,$(CJSON_VERSION))
CJSON_INSTALL_STAGING = YES
CJSON_LICENSE = MIT
CJSON_LICENSE_FILES = LICENSE
CJSON_CONF_OPTS += \
	-DENABLE_CJSON_TEST=OFF

$(eval $(cmake-package))
