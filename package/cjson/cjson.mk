################################################################################
#
# cjson
#
################################################################################

CJSON_VERSION = v1.2.1
CJSON_SITE = $(call github,DaveGamble,cjson,$(CJSON_VERSION))
CJSON_INSTALL_STAGING = YES
CJSON_LICENSE = MIT
CJSON_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
