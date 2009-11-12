#############################################################
#
# libcdaudio
#
#############################################################

LIBCDAUDIO_VERSION = 0.99.12p2
LIBCDAUDIO_SOURCE = libcdaudio-$(LIBCDAUDIO_VERSION).tar.gz
LIBCDAUDIO_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/libcdaudio/libcdaudio/$(LIBCDAUDIO_VERSION)/
LIBCDAUDIO_AUTORECONF = YES
LIBCDAUDIO_LIBTOOL_PATCH = YES
LIBCDAUDIO_INSTALL_STAGING = YES
LIBCDAUDIO_INSTALL_TARGET = YES

$(eval $(call AUTOTARGETS,package/multimedia,libcdaudio))
