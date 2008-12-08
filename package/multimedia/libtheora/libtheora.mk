#############################################################
#
# libtheora
#
#############################################################
LIBTHEORA_VERSION = 1.0
LIBTHEORA_SOURCE = libtheora-$(LIBTHEORA_VERSION).tar.bz2
LIBTHEORA_SITE = http://downloads.xiph.org/releases/theora
LIBTHEORA_INSTALL_STAGING = YES

LIBTHEORA_CONF_OPT = \
		--disable-oggtest \
		--disable-vorbistest \
		--disable-sdltest \
		--disable-examples

LIBTHEORA_DEPENDENCIES = libogg libvorbis pkgconfig

$(eval $(call AUTOTARGETS,package/multimedia,libtheora))
