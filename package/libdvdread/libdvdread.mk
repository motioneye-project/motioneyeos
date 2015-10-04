################################################################################
#
# libdvdread
#
################################################################################

LIBDVDREAD_VERSION = 4.2.1
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VERSION).tar.xz
LIBDVDREAD_SITE = http://dvdnav.mplayerhq.hu/releases
# configure not shipped
LIBDVDREAD_AUTORECONF = YES
LIBDVDREAD_INSTALL_STAGING = YES
LIBDVDREAD_CONFIG_SCRIPTS = dvdread-config
LIBDVDREAD_LICENSE = GPLv2+
LIBDVDREAD_LICENSE_FILES = COPYING

$(eval $(autotools-package))
