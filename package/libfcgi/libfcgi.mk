################################################################################
#
# libfcgi
#
################################################################################

LIBFCGI_VERSION = 2.4.2
LIBFCGI_SITE = $(call github,FastCGI-Archives,fcgi2,$(LIBFCGI_VERSION))
LIBFCGI_LICENSE = OML
LIBFCGI_LICENSE_FILES = LICENSE.TERMS
LIBFCGI_INSTALL_STAGING = YES
LIBFCGI_AUTORECONF = YES

$(eval $(autotools-package))
