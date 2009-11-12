#############################################################
#
# libdvdread
#
#############################################################

LIBDVDREAD_VERSION = 4.1.3
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.bz2
LIBDVDREAD_SITE = http://www.mplayerhq.hu/MPlayer/releases/dvdnav/
LIBDVDREAD_AUTORECONF = YES
LIBDVDREAD_LIBTOOL_PATCH = YES
LIBDVDREAD_INSTALL_STAGING = YES
LIBDVDREAD_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package/multimedia,libdvdread))
