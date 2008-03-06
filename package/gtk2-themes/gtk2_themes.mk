#############################################################
#
# GTK Theme - Hicolour
#
#############################################################
GTK2_THEME_HICOLOR_VERSION = 0.10
GTK2_THEME_HICOLOR_SOURCE = hicolor-icon-theme-$(GTK2_THEME_HICOLOR_VERSION).tar.gz
GTK2_THEME_HICOLOR_SITE = http://icon-theme.freedesktop.org/releases/
GTK2_THEME_HICOLOR_INSTALL_STAGING = NO
GTK2_THEME_HICOLOR_INSTALL_TARGET = YES
GTK2_THEME_HICOLOR_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

GTK2_THEME_HICOLOR_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
        --build=$(GNU_HOST_NAME) --prefix=/usr \
        --includedir=/usr/include

GTK2_THEME_HICOLOR_DEPENDENCIES = libgtk2

$(eval $(call AUTOTARGETS,package,gtk2_theme_hicolor))
