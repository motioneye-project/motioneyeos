################################################################################
#
# zxing-cpp
#
################################################################################

ZXING_CPP_VERSION = fa34227d26e0b388e65b81936a2681952928f5be
ZXING_CPP_SITE = $(call github,glassechidna,zxing-cpp,$(ZXING_CPP_VERSION))
ZXING_CPP_LICENSE = Apache-2.0
ZXING_CPP_LICENSE_FILES = COPYING
ZXING_CPP_INSTALL_STAGING = YES
ZXING_CPP_SUPPORTS_IN_SOURCE_BUILD = NO

ifeq ($(BR2_PACKAGE_LIBICONV),y)
ZXING_CPP_DEPENDENCIES += libiconv
endif

$(eval $(cmake-package))
