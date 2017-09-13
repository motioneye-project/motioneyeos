################################################################################
#
# libgpiod
#
################################################################################

LIBGPIOD_VERSION = 0.3.1
LIBGPIOD_SOURCE = libgpiod-$(LIBGPIOD_VERSION).tar.xz
LIBGPIOD_SITE = https://www.kernel.org/pub/software/libs/libgpiod
LIBGPIOD_LICENSE = LGPL-2.1+
LIBGPIOD_LICENSE_FILES = COPYING
LIBGPIOD_INSTALL_STAGING = YES

LIBGPIOD_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_LIBGPIOD_TOOLS),y)
LIBGPIOD_CONF_OPTS += --enable-tools
else
LIBGPIOD_CONF_OPTS += --disable-tools
endif

$(eval $(autotools-package))
