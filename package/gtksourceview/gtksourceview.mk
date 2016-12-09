################################################################################
#
# gtksourceview
#
################################################################################

GTKSOURCEVIEW_VERSION_MAJOR = 3.22
GTKSOURCEVIEW_VERSION = $(GTKSOURCEVIEW_VERSION_MAJOR).2
GTKSOURCEVIEW_SOURCE = gtksourceview-$(GTKSOURCEVIEW_VERSION).tar.xz
GTKSOURCEVIEW_SITE = \
	http://ftp.gnome.org/pub/gnome/sources/gtksourceview/$(GTKSOURCEVIEW_VERSION_MAJOR)
GTKSOURCEVIEW_LICENSE = LGPLv2.1+
GTKSOURCEVIEW_LICENSE_FILES = COPYING
GTKSOURCEVIEW_INSTALL_STAGING = YES
GTKSOURCEVIEW_DEPENDENCIES = host-pkgconf libglib2 libxml2 libgtk3

$(eval $(autotools-package))
