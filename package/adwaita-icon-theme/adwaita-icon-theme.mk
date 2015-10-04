################################################################################
#
# adwaita-icon-theme
#
################################################################################

ADWAITA_ICON_THEME_VERSION_MAJOR = 3.14
ADWAITA_ICON_THEME_VERSION = $(ADWAITA_ICON_THEME_VERSION_MAJOR).0
ADWAITA_ICON_THEME_SITE = ftp://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/$(ADWAITA_ICON_THEME_VERSION_MAJOR)
ADWAITA_ICON_THEME_SOURCE = adwaita-icon-theme-$(ADWAITA_ICON_THEME_VERSION).tar.xz
ADWAITA_ICON_THEME_LICENSE = LGPLv3 or CC-BY-SA-3.0
ADWAITA_ICON_THEME_LICENSE_FILES = COPYING COPYING_LGPL COPYING_CCBYSA3
ADWAITA_ICON_THEME_DEPENDENCIES = host-intltool host-libgtk3

$(eval $(autotools-package))
