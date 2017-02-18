################################################################################
#
# hicolor-icon-theme
#
################################################################################

HICOLOR_ICON_THEME_VERSION = 0.15
HICOLOR_ICON_THEME_SITE = http://icon-theme.freedesktop.org/releases
HICOLOR_ICON_THEME_SOURCE = hicolor-icon-theme-$(HICOLOR_ICON_THEME_VERSION).tar.xz
HICOLOR_ICON_THEME_LICENSE = GPLv2
HICOLOR_ICON_THEME_LICENSE_FILES = COPYING

$(eval $(autotools-package))
