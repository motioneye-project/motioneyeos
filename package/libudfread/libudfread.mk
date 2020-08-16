################################################################################
#
# libudfread
#
################################################################################

LIBUDFREAD_VERSION = 1.0.0
LIBUDFREAD_SOURCE = libudfread-$(LIBUDFREAD_VERSION).tar.bz2
LIBUDFREAD_SITE = https://code.videolan.org/videolan/libudfread/-/archive/$(LIBUDFREAD_VERSION)
LIBUDFREAD_AUTORECONF = YES
LIBUDFREAD_INSTALL_STAGING = YES
LIBUDFREAD_LICENSE = LGPL-2.1+
LIBUDFREAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
