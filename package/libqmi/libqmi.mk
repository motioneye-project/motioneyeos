################################################################################
#
# libqmi
#
################################################################################

LIBQMI_VERSION = 1.16.0
LIBQMI_SITE = http://www.freedesktop.org/software/libqmi
LIBQMI_SOURCE = libqmi-$(LIBQMI_VERSION).tar.xz
LIBQMI_LICENSE = LGPL-2.0+ (library), GPL-2.0+ (programs)
LIBQMI_LICENSE_FILES = COPYING
LIBQMI_INSTALL_STAGING = YES

LIBQMI_DEPENDENCIES = libglib2

# we don't want -Werror
LIBQMI_CONF_OPTS = --enable-more-warnings=no

$(eval $(autotools-package))
