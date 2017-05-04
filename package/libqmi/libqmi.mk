################################################################################
#
# libqmi
#
################################################################################

LIBQMI_VERSION = 1.18.0
LIBQMI_SITE = http://www.freedesktop.org/software/libqmi
LIBQMI_SOURCE = libqmi-$(LIBQMI_VERSION).tar.xz
LIBQMI_LICENSE = LGPL-2.0+ (library), GPL-2.0+ (programs)
LIBQMI_LICENSE_FILES = COPYING
LIBQMI_INSTALL_STAGING = YES
# 0001-musl-compat-canonicalize_file_name.patch
LIBQMI_AUTORECONF = YES

LIBQMI_DEPENDENCIES = libglib2

# we don't want -Werror and disable gudev Gobject bindings
LIBQMI_CONF_OPTS = --enable-more-warnings=no --without-udev

$(eval $(autotools-package))
