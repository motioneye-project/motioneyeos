################################################################################
#
# ltris
#
################################################################################

LTRIS_SITE = http://downloads.sourceforge.net/lgames/ltris/
LTRIS_VERSION = 1.0.19
LTRIS_LICENSE = GPLv2+
LTRIS_LICENSE_FILES = COPYING

LTRIS_DEPENDENCIES = sdl

LTRIS_CONF_ENV = \
	SDL_CONFIG="$(STAGING_DIR)/usr/bin/sdl-config"

ifeq ($(BR2_PACKAGE_LTRIS_AUDIO),y)
LTRIS_DEPENDENCIES += sdl_mixer
LTRIS_CONF_OPT += --enable-audio=yes
else
LTRIS_CONF_OPT += --disable-audio
endif

ifeq ($(BR2_PACKAGE_GETTEXT),y)
LTRIS_DEPENDENCIES += gettext
LTRIS_CONF_ENV += LIBS=-lintl
endif

$(eval $(autotools-package))
