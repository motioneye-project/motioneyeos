################################################################################
#
# libkcapi
#
################################################################################

LIBKCAPI_VERSION = 1.1.4
LIBKCAPI_SOURCE = libkcapi-$(LIBKCAPI_VERSION).tar.xz
LIBKCAPI_SITE = http://www.chronox.de/libkcapi
LIBKCAPI_AUTORECONF = YES
LIBKCAPI_INSTALL_STAGING = YES
LIBKCAPI_LICENSE = BSD-3-Clause (library), BSD-3-Clause or GPL-2.0 (programs)
LIBKCAPI_LICENSE_FILES = COPYING COPYING.gplv2 COPYING.bsd
LIBKCAPI_CONF_ENV = \
	ac_cv_path_DB2PDF="" \
	ac_cv_path_DB2PS="" \
	ac_cv_path_XMLTO=""

ifeq ($(BR2_PACKAGE_LIBKCAPI_HASHER),y)
LIBKCAPI_CONF_OPTS += --enable-kcapi-hasher
else
LIBKCAPI_CONF_OPTS += --disable-kcapi-hasher
endif

ifeq ($(BR2_PACKAGE_LIBKCAPI_RNGAPP),y)
LIBKCAPI_CONF_OPTS += --enable-kcapi-rngapp
else
LIBKCAPI_CONF_OPTS += --disable-kcapi-rngapp
endif

ifeq ($(BR2_PACKAGE_LIBKCAPI_SPEED),y)
LIBKCAPI_CONF_OPTS += --enable-kcapi-speed
else
LIBKCAPI_CONF_OPTS += --disable-kcapi-speed
endif

ifeq ($(BR2_PACKAGE_LIBKCAPI_TEST),y)
LIBKCAPI_CONF_OPTS += --enable-kcapi-test
else
LIBKCAPI_CONF_OPTS += --disable-kcapi-test
endif

$(eval $(autotools-package))
