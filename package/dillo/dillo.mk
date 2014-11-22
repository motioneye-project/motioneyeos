################################################################################
#
# dillo
#
################################################################################

DILLO_VERSION = 3.0.4
DILLO_SOURCE = dillo-$(DILLO_VERSION).tar.bz2
DILLO_SITE = http://www.dillo.org/download
DILLO_LICENSE = GPLv3+
DILLO_LICENSE_FILES = COPYING
# dillo-0001-configure.ac-change-fltk-config-test-to-be-more-cros.patch
# touches configure.ac
DILLO_AUTORECONF = YES

DILLO_DEPENDENCIES = fltk

DILLO_CONF_ENV = ac_cv_path_FLTK_CONFIG=$(STAGING_DIR)/usr/bin/fltk-config

DILLO_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	DILLO_CONF_OPTS += --enable-ssl
	DILLO_DEPENDENCIES += openssl
else
	DILLO_CONF_OPTS += --disable-ssl
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
	DILLO_CONF_OPTS += --enable-png
	DILLO_DEPENDENCIES += libpng
	DILLO_CONF_ENV += PNG_CONFIG=$(STAGING_DIR)/usr/bin/libpng-config
else
	DILLO_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
	DILLO_CONF_OPTS += --enable-jpeg
	DILLO_DEPENDENCIES += libjpeg
else
	DILLO_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
	DILLO_CONF_OPTS += --enable-threaded-dns
else
	DILLO_CONF_OPTS += --disable-threaded-dns
endif

$(eval $(autotools-package))
