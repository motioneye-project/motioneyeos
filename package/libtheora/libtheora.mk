################################################################################
#
# libtheora
#
################################################################################

LIBTHEORA_VERSION = 1.1.1
LIBTHEORA_SOURCE = libtheora-$(LIBTHEORA_VERSION).tar.xz
LIBTHEORA_SITE = http://downloads.xiph.org/releases/theora
LIBTHEORA_INSTALL_STAGING = YES
# We're patching Makefile.am
LIBTHEORA_AUTORECONF = YES
LIBTHEORA_LICENSE = BSD-3c
LIBTHEORA_LICENSE_FILES = COPYING LICENSE

LIBTHEORA_CONF_OPTS = \
	--disable-oggtest \
	--disable-vorbistest \
	--disable-sdltest \
	--disable-examples \
	--disable-spec

LIBTHEORA_DEPENDENCIES = libogg libvorbis host-pkgconf

$(eval $(autotools-package))
