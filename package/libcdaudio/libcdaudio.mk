################################################################################
#
# libcdaudio
#
################################################################################

LIBCDAUDIO_VERSION = 0.99.12p2
LIBCDAUDIO_SITE = http://downloads.sourceforge.net/project/libcdaudio/libcdaudio/$(LIBCDAUDIO_VERSION)
LIBCDAUDIO_INSTALL_STAGING = YES
LIBCDAUDIO_CONFIG_SCRIPTS = libcdaudio-config
LIBCDAUDIO_LICENSE = GPL-2.0+
LIBCDAUDIO_LICENSE_FILES = COPYING

# fix configure failure when the toolchain doesn't have C++ support
LIBCDAUDIO_AUTORECONF = YES

$(eval $(autotools-package))
