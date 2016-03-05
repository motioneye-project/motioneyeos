################################################################################
#
# gtkmm3
#
################################################################################

GTKMM3_VERSION_MAJOR = 3.14
GTKMM3_VERSION = $(GTKMM3_VERSION_MAJOR).0
GTKMM3_SOURCE = gtkmm-$(GTKMM3_VERSION).tar.xz
GTKMM3_SITE = http://ftp.gnome.org/pub/gnome/sources/gtkmm/$(GTKMM3_VERSION_MAJOR)
GTKMM3_LICENSE = LGPLv2.1+ (library), GPLv2+ (tools)
GTKMM3_LICENSE_FILES = COPYING COPYING.tools
GTKMM3_INSTALL_STAGING = YES
GTKMM3_DEPENDENCIES = atkmm cairomm glibmm libgtk3 libsigc pangomm host-pkgconf

# Explicit use of C++11 to build with newer *mm dependencies that require C++11.
#
# The most recent release of *mm-related libraries require C++11. This project's
# dependencies (ex. libpangomm) are updated and enforce the C++11 standard.
# Since the gtkmm3 must match the libgtk3 version, the useable version of
# gtkmm3 does not have this enforcement; however, to build with the most
# recent version of the dependencies, gtkmm3 requires to be built with
# `-std=c++11`. The following enforces C++11 standard. When libgtk3 is updated,
# followed by a gtkmm3 update, this flag modification can be removed.
GTKMM3_CONF_ENV = CPPFLAGS="$(TARGET_CPPFLAGS) -std=c++11"

$(eval $(autotools-package))
