################################################################################
#
# libcdaudio
#
################################################################################

LIBCDAUDIO_VERSION = 0.99.12p2
LIBCDAUDIO_SITE = http://downloads.sourceforge.net/project/libcdaudio/libcdaudio/$(LIBCDAUDIO_VERSION)/
LIBCDAUDIO_INSTALL_STAGING = YES
LIBCDAUDIO_CONFIG_SCRIPTS = libcdaudio-config
LIBCDAUDIO_LICENSE = GPLv2+
LIBCDAUDIO_LICENSE_FILES = COPYING

$(eval $(autotools-package))
