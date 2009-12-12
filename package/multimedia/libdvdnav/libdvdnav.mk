#############################################################
#
# libdvdnav
#
#############################################################

LIBDVDNAV_VERSION = 4.1.3
LIBDVDNAV_SOURCE = libdvdnav-$(LIBDVDNAV_VERSION).tar.bz2
LIBDVDNAV_SITE = http://www.mplayerhq.hu/MPlayer/releases/dvdnav
LIBDVDNAV_AUTORECONF = YES
LIBDVDNAV_INSTALL_STAGING = YES
LIBDVDNAV_INSTALL_TARGET = YES

LIBDVDNAV_DEPENDENCIES = libdvdread

# By default libdvdnav tries to find dvdread-config in $PATH. Because
# of cross compilation, we prefer using pkg-config.
LIBDVDNAV_CONF_OPT = --with-dvdread-config="$(PKG_CONFIG_HOST_BINARY) dvdread"

$(eval $(call AUTOTARGETS,package/multimedia,libdvdnav))
