################################################################################
#
# qjson
#
################################################################################

QJSON_VERSION = 0.8.1

QJSON_SITE = http://github.com/flavio/qjson/tarball/$(QJSON_VERSION)
QJSON_INSTALL_STAGING = YES
QJSON_DEPENDENCIES =  qt
QJSON_LICENSE = LGPLv2.1
QJSON_LICENSE_FILES = COPYING.lib

$(eval $(cmake-package))
