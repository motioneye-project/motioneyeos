################################################################################
#
# librsvg
#
################################################################################

LIBRSVG_VERSION_MAJOR = 2.26
LIBRSVG_VERSION = $(LIBRSVG_VERSION_MAJOR).3
LIBRSVG_SITE = http://ftp.gnome.org/pub/GNOME/sources/librsvg/$(LIBRSVG_VERSION_MAJOR)
LIBRSVG_INSTALL_STAGING = YES
LIBRSVG_CONF_OPTS = --disable-tools
LIBRSVG_DEPENDENCIES = libxml2 cairo pango libglib2 gdk-pixbuf
LIBRSVG_LICENSE = LGPLv2+
LIBRSVG_LICENSE_FILES = COPYING.LIB

# If we have Gtk2, let's build it first to benefit from librsvg Gtk
# support.
ifeq ($(BR2_PACKAGE_LIBGTK2),y)
LIBRSVG_DEPENDENCIES += libgtk2
endif

$(eval $(autotools-package))
