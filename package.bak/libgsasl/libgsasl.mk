################################################################################
#
# libgsasl
#
################################################################################

LIBGSASL_VERSION = 1.8.0
LIBGSASL_SITE = $(BR2_GNU_MIRROR)/gsasl
LIBGSASL_LICENSE = LGPLv2.1+ (library), GPLv3+ (programs)
LIBGSASL_LICENSE_FILES = README COPYING.LIB COPYING
LIBGSASL_INSTALL_STAGING = YES
# It doesn't seem to build with our libgcrypt so better be safe
LIBGSASL_CONF_OPTS = --without-libgcrypt

ifeq ($(BR2_PACKAGE_LIBIDN),y)
LIBGSASL_CONF_OPTS += --with-libidn-prefix=$(STAGING_DIR)/usr
LIBGSASL_DEPENDENCIES += libidn
else
LIBGSASL_CONF_OPTS += --without-stringprep
endif

$(eval $(autotools-package))
