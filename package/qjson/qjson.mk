################################################################################
#
# qjson
#
################################################################################

QJSON_VERSION = 0.8.1

QJSON_SITE = $(call github,flavio,qjson,$(QJSON_VERSION))
QJSON_INSTALL_STAGING = YES
QJSON_DEPENDENCIES =  qt
QJSON_LICENSE = LGPLv2.1
QJSON_LICENSE_FILES = COPYING.lib

$(eval $(cmake-package))
