################################################################################
#
# libdvdcss
#
################################################################################

LIBDVDCSS_VERSION = 1.4.0
LIBDVDCSS_SOURCE = libdvdcss-$(LIBDVDCSS_VERSION).tar.bz2
LIBDVDCSS_SITE = http://www.videolan.org/pub/videolan/libdvdcss/$(LIBDVDCSS_VERSION)
LIBDVDCSS_INSTALL_STAGING = YES
LIBDVDCSS_LICENSE = GPL-2.0+
LIBDVDCSS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
