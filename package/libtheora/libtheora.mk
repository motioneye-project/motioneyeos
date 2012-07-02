#############################################################
#
# libtheora
#
#############################################################
LIBTHEORA_VERSION = 1.1.1
LIBTHEORA_SOURCE = libtheora-$(LIBTHEORA_VERSION).tar.bz2
LIBTHEORA_SITE = http://downloads.xiph.org/releases/theora
LIBTHEORA_INSTALL_STAGING = YES

LIBTHEORA_CONF_OPT = \
		--disable-oggtest \
		--disable-vorbistest \
		--disable-sdltest \
		--disable-examples \
		--disable-spec

LIBTHEORA_DEPENDENCIES = libogg libvorbis host-pkg-config

$(eval $(autotools-package))
