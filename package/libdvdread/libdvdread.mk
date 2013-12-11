################################################################################
#
# libdvdread
#
################################################################################

LIBDVDREAD_VERSION = 4.1.3
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.bz2
LIBDVDREAD_SITE = http://dvdnav.mplayerhq.hu/releases
LIBDVDREAD_AUTORECONF = YES
LIBDVDREAD_LIBTOOL_PATCH = YES
LIBDVDREAD_INSTALL_STAGING = YES
LIBDVDREAD_CONFIG_SCRIPTS = dvdread-config
LIBDVDREAD_LICENSE = GPLv2+
LIBDVDREAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
