################################################################################
#
# gtk2-theme-hicolor
#
################################################################################

GTK2_THEME_HICOLOR_VERSION = 0.10
GTK2_THEME_HICOLOR_SOURCE = hicolor-icon-theme-$(GTK2_THEME_HICOLOR_VERSION).tar.gz
GTK2_THEME_HICOLOR_SITE = http://icon-theme.freedesktop.org/releases
GTK2_THEME_HICOLOR_DEPENDENCIES = libgtk2
GTK2_THEME_HICOLOR_LICENSE = GPLv2
GTK2_THEME_HICOLOR_LICENSE_FILES = COPYING

$(eval $(autotools-package))
