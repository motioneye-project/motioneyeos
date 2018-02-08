################################################################################
#
# libmbim
#
################################################################################

LIBMBIM_VERSION = 1.16.0
LIBMBIM_SITE = http://www.freedesktop.org/software/libmbim
LIBMBIM_SOURCE = libmbim-$(LIBMBIM_VERSION).tar.xz
LIBMBIM_LICENSE = LGPL-2.0+ (library), GPL-2.0+ (programs)
LIBMBIM_LICENSE_FILES = COPYING COPYING.LIB
LIBMBIM_INSTALL_STAGING = YES

LIBMBIM_DEPENDENCIES = libglib2

# we don't want -Werror
LIBMBIM_CONF_OPTS = --enable-more-warnings=no

# if libgudev available, request udev support
ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
LIBMBIM_DEPENDENCIES += libgudev
LIBMBIM_CONF_OPTS += --with-udev
else
LIBMBIM_CONF_OPTS += --without-udev
endif

$(eval $(autotools-package))
