#############################################################
#
# libdvdread
#
#############################################################

LIBDVDREAD_VERSION = 4.1.3
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.bz2
LIBDVDREAD_SITE = http://dvdnav.mplayerhq.hu/releases
LIBDVDREAD_AUTORECONF = YES
LIBDVDREAD_LIBTOOL_PATCH = YES
LIBDVDREAD_INSTALL_STAGING = YES

$(eval $(autotools-package))
