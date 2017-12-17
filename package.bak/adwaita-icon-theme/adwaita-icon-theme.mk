################################################################################
#
# adwaita-icon-theme
#
################################################################################

ADWAITA_ICON_THEME_VERSION_MAJOR = 3.22
ADWAITA_ICON_THEME_VERSION = $(ADWAITA_ICON_THEME_VERSION_MAJOR).0
ADWAITA_ICON_THEME_SITE = http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/$(ADWAITA_ICON_THEME_VERSION_MAJOR)
ADWAITA_ICON_THEME_SOURCE = adwaita-icon-theme-$(ADWAITA_ICON_THEME_VERSION).tar.xz
ADWAITA_ICON_THEME_INSTALL_STAGING = YES
ADWAITA_ICON_THEME_LICENSE = LGPL-3.0 or CC-BY-SA-3.0
ADWAITA_ICON_THEME_LICENSE_FILES = COPYING COPYING_LGPL COPYING_CCBYSA3
ADWAITA_ICON_THEME_DEPENDENCIES = host-intltool host-libgtk3

$(eval $(autotools-package))
