#############################################################
#
# libvorbis
#
#############################################################

LIBVORBIS_VERSION = 1.3.3
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VERSION).tar.gz
LIBVORBIS_SITE = http://downloads.xiph.org/releases/vorbis/$(LIBVORBIS-SOURCE)
LIBVORBIS_INSTALL_STAGING = YES

LIBVORBIS_CONF_OPT = --disable-oggtest

LIBVORBIS_DEPENDENCIES = host-pkg-config libogg

$(eval $(autotools-package))
