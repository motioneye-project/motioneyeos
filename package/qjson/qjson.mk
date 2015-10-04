################################################################################
#
# qjson
#
################################################################################

QJSON_VERSION = ba273682a9d33a7b3090e74f4742b5f3bf6c9b02
QJSON_SITE = $(call github,flavio,qjson,$(QJSON_VERSION))
QJSON_INSTALL_STAGING = YES
QJSON_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_QT),qt) \
	$(if $(BR2_PACKAGE_QT5),qt5base)
QJSON_LICENSE = LGPLv2.1
QJSON_LICENSE_FILES = COPYING.lib

$(eval $(cmake-package))
