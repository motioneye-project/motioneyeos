################################################################################
#
# zxing-cpp
#
################################################################################

ZXING_CPP_VERSION = 0db7f855135222becff193671faae79c083424b6
ZXING_CPP_SITE = $(call github,glassechidna,zxing-cpp,$(ZXING_CPP_VERSION))
ZXING_CPP_LICENSE = Apache-2.0
ZXING_CPP_LICENSE_FILES = COPYING
ZXING_CPP_INSTALL_STAGING = YES
ZXING_CPP_SUPPORTS_IN_SOURCE_BUILD = NO

ifeq ($(BR2_PACKAGE_LIBICONV),y)
ZXING_CPP_DEPENDENCIES += libiconv
endif

# build all targets except testrunner (needs c++11 support)
ZXING_CPP_MAKE_OPTS = libzxing zxing

$(eval $(cmake-package))
