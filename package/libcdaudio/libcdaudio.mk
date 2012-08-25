#############################################################
#
# libcdaudio
#
#############################################################

LIBCDAUDIO_VERSION = 0.99.12p2
LIBCDAUDIO_SOURCE = libcdaudio-$(LIBCDAUDIO_VERSION).tar.gz
LIBCDAUDIO_SITE = http://downloads.sourceforge.net/project/libcdaudio/libcdaudio/$(LIBCDAUDIO_VERSION)/
LIBCDAUDIO_AUTORECONF = YES
LIBCDAUDIO_LIBTOOL_PATCH = YES
LIBCDAUDIO_INSTALL_STAGING = YES

$(eval $(autotools-package))
