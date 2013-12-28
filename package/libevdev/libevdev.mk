################################################################################
#
# libevdev
#
################################################################################

LIBEVDEV_VERSION = 0.5
LIBEVDEV_SITE = http://cgit.freedesktop.org/libevdev/snapshot
LIBEVDEV_LICENSE = X11
LIBEVDEV_LICENSE_FILES = COPYING

# Uses PKG_CHECK_MODULES() in configure.ac
LIBEVDEV_DEPENDENCIES = host-pkgconf

# Needs Python to generate a header file
# We can't rely on the system Python, since it may be too old
# (missing argparse in python 2.6)
LIBEVDEV_DEPENDENCIES += host-python

# package source code coming from git, so it doesn't have generated
# configure and Makefile.in
LIBEVDEV_AUTORECONF = YES
LIBEVDEV_INSTALL_STAGING = YES

$(eval $(autotools-package))
