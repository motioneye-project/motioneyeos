################################################################################
#
# libatasmart
#
################################################################################

LIBATASMART_VERSION = 0.19
LIBATASMART_SOURCE = libatasmart-$(LIBATASMART_VERSION).tar.xz
LIBATASMART_SITE = http://0pointer.de/public
LIBATASMART_LICENSE = LGPL-2.1
LIBATASMART_LICENSE_FILES = LGPL
LIBATASMART_INSTALL_STAGING = YES

# package doesn't include configure script
LIBATASMART_AUTORECONF = YES

LIBATASMART_DEPENDENCIES = udev

$(eval $(autotools-package))
