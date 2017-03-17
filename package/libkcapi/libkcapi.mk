################################################################################
#
# libkcapi
#
################################################################################

LIBKCAPI_VERSION = a039f8a5adca57dc69a19d7361600c2f410e0c26
LIBKCAPI_SITE = $(call github,smuellerDD,libkcapi,$(LIBKCAPI_VERSION))
LIBKCAPI_AUTORECONF = YES
LIBKCAPI_INSTALL_STAGING = YES
LIBKCAPI_LICENSE = BSD-3c (library), BSD-3c or GPLv2 (programs)
LIBKCAPI_LICENSE_FILES = COPYING COPYING.gplv2 COPYING.bsd

ifeq ($(BR2_PACKAGE_LIBKCAPI_APPS),y)
LIBKCAPI_CONF_OPTS += --enable-kcapi-speed --enable-kcapi-test --enable-apps
else
LIBKCAPI_CONF_OPTS += --disable-kcapi-speed --disable-kcapi-test --disable-apps
endif

$(eval $(autotools-package))
