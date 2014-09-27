################################################################################
#
# libdvdnav
#
################################################################################

LIBDVDNAV_VERSION = 4.2.1
LIBDVDNAV_SOURCE = libdvdnav-$(LIBDVDNAV_VERSION).tar.xz
LIBDVDNAV_SITE = http://dvdnav.mplayerhq.hu/releases
# configure not shipped
LIBDVDNAV_AUTORECONF = YES
LIBDVDNAV_INSTALL_STAGING = YES
LIBDVDNAV_CONFIG_SCRIPTS = dvdnav-config
LIBDVDNAV_DEPENDENCIES = libdvdread host-pkgconf
LIBDVDNAV_LICENSE = GPLv2+
LIBDVDNAV_LICENSE_FILES = COPYING

# By default libdvdnav tries to find dvdread-config in $PATH. Because
# of cross compilation, we prefer using pkg-config.
LIBDVDNAV_CONF_OPTS = --with-dvdread-config="$(PKG_CONFIG_HOST_BINARY) dvdread"

$(eval $(autotools-package))
