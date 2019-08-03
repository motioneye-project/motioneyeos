################################################################################
#
# jack1
#
################################################################################

JACK1_VERSION = 0.125.0
JACK1_SOURCE = jack-audio-connection-kit-$(JACK1_VERSION).tar.gz
JACK1_SITE = http://jackaudio.org/downloads
JACK1_LICENSE = GPL-2.0+ (jack server), LGPL-2.1+ (jack library)
JACK1_LICENSE_FILES = COPYING COPYING.GPL COPYING.LGPL
JACK1_INSTALL_STAGING = YES

# Dependency to celt can't be met: jack1 requires celt >= 0.8.0 but we
# only have 0.5.1.3 and we cannot upgrade.
JACK1_DEPENDENCIES = host-pkgconf alsa-lib berkeleydb libsamplerate libsndfile

ifeq ($(BR2_PACKAGE_READLINE),y)
JACK1_DEPENDENCIES += readline
endif

JACK1_CONF_OPTS = --without-html-dir --disable-oss

$(eval $(autotools-package))
