################################################################################
#
# libkcapi
#
################################################################################

LIBKCAPI_VERSION = 0.14.0
LIBKCAPI_SOURCE = libkcapi-$(LIBKCAPI_VERSION).tar.xz
LIBKCAPI_SITE = http://www.chronox.de/libkcapi
LIBKCAPI_AUTORECONF = YES
LIBKCAPI_INSTALL_STAGING = YES
LIBKCAPI_LICENSE = BSD-3-Clause (library), BSD-3-Clause or GPL-2.0 (programs)
LIBKCAPI_LICENSE_FILES = COPYING COPYING.gplv2 COPYING.bsd

ifeq ($(BR2_PACKAGE_LIBKCAPI_APPS),y)
LIBKCAPI_CONF_OPTS += \
	--enable-kcapi-speed \
	--enable-kcapi-test \
	--enable-kcapi-hasher \
	--enable-kcapi-rngapp
else
LIBKCAPI_CONF_OPTS += \
	--disable-kcapi-speed \
	--disable-kcapi-test \
	--disable-kcapi-hasher \
	--disable-kcapi-rngapp
endif

$(eval $(autotools-package))
