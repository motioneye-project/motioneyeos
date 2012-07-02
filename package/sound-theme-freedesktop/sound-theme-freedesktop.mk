#############################################################
#
# sound-theme-freedesktop
#
#############################################################
SOUND_THEME_FREEDESKTOP_VERSION = 0.7
SOUND_THEME_FREEDESKTOP_SITE = \
	http://people.freedesktop.org/~mccann/dist
SOUND_THEME_FREEDESKTOP_SOURCE = \
	sound-theme-freedesktop-$(SOUND_THEME_FREEDESKTOP_VERSION).tar.bz2
SOUND_THEME_FREEDESKTOP_DEPENDENCIES = host-intltool

$(eval $(autotools-package))
