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
LIBGSASL_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBIDN),libidn)

$(eval $(autotools-package))
