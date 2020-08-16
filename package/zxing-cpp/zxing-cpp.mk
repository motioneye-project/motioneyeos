################################################################################
#
# zxing-cpp
#
################################################################################

ZXING_CPP_VERSION = e0e40ddec63f38405aca5c8c1ff60b85ec8b1f10
ZXING_CPP_SITE = $(call github,glassechidna,zxing-cpp,$(ZXING_CPP_VERSION))
ZXING_CPP_LICENSE = Apache-2.0
ZXING_CPP_LICENSE_FILES = COPYING
ZXING_CPP_INSTALL_STAGING = YES
ZXING_CPP_SUPPORTS_IN_SOURCE_BUILD = NO
ZXING_CPP_CONF_OPTS = -DBUILD_TESTING=OFF

ifeq ($(BR2_PACKAGE_LIBICONV),y)
ZXING_CPP_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_OPENCV_LIB_HIGHGUI),y)
ZXING_CPP_DEPENDENCIES += opencv
ZXING_CPP_CONF_OPTS += -DBUILD_OPENCV=ON
else
ZXING_CPP_CONF_OPTS += -DBUILD_OPENCV=OFF
endif

$(eval $(cmake-package))
