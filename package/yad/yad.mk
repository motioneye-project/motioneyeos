################################################################################
#
# yad
#
################################################################################

YAD_VERSION = 0.33.1
YAD_SOURCE = yad-$(YAD_VERSION).tar.xz
YAD_SITE = http://sourceforge.net/projects/yad-dialog/files
YAD_LICENSE = GPL-3.0
YAD_LICENSE_FILES = COPYING
YAD_DEPENDENCIES = host-intltool host-pkgconf
YAD_CONF_OPTS = --enable-html=no

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
YAD_DEPENDENCIES += libgtk3
YAD_CONF_OPTS += --with-gtk=gtk3
else
YAD_DEPENDENCIES += libgtk2
YAD_CONF_OPTS += --with-gtk=gtk2
endif

$(eval $(autotools-package))
