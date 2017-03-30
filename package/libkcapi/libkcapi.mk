################################################################################
#
# libkcapi
#
################################################################################

LIBKCAPI_VERSION = 79cb80714ebcbae2b9de9bb5aca9a6a546f2f121
LIBKCAPI_SITE = $(call github,smuellerDD,libkcapi,$(LIBKCAPI_VERSION))
LIBKCAPI_AUTORECONF = YES
LIBKCAPI_INSTALL_STAGING = YES
LIBKCAPI_LICENSE = BSD-3-Clause (library), BSD-3-Clause or GPL-2.0 (programs)
LIBKCAPI_LICENSE_FILES = COPYING COPYING.gplv2 COPYING.bsd

ifeq ($(BR2_PACKAGE_LIBKCAPI_APPS),y)
LIBKCAPI_CONF_OPTS += --enable-kcapi-speed --enable-kcapi-test --enable-apps
else
LIBKCAPI_CONF_OPTS += --disable-kcapi-speed --disable-kcapi-test --disable-apps
endif

$(eval $(autotools-package))
