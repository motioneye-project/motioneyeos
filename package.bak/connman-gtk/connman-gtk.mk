################################################################################
#
# connman-gtk
#
################################################################################

CONNMAN_GTK_VERSION = 1.1.1
CONNMAN_GTK_SITE = https://github.com/jgke/connman-gtk/releases/download/v$(CONNMAN_GTK_VERSION)
CONNMAN_GTK_SOURCE = connman-gtk-$(CONNMAN_GTK_VERSION).tar.bz2
CONNMAN_GTK_INSTALL_STAGING = YES
CONNMAN_GTK_DEPENDENCIES = host-intltool connman libglib2 libgtk3
CONNMAN_GTK_LICENSE = GPLv2+
CONNMAN_GTK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
