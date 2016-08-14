################################################################################
#
# gtkmm3
#
################################################################################

GTKMM3_VERSION_MAJOR = 3.20
GTKMM3_VERSION = $(GTKMM3_VERSION_MAJOR).1
GTKMM3_SOURCE = gtkmm-$(GTKMM3_VERSION).tar.xz
GTKMM3_SITE = http://ftp.gnome.org/pub/gnome/sources/gtkmm/$(GTKMM3_VERSION_MAJOR)
GTKMM3_LICENSE = LGPLv2.1+ (library), GPLv2+ (tools)
GTKMM3_LICENSE_FILES = COPYING COPYING.tools
GTKMM3_INSTALL_STAGING = YES
GTKMM3_DEPENDENCIES = atkmm cairomm glibmm libgtk3 libsigc pangomm host-pkgconf

$(eval $(autotools-package))
