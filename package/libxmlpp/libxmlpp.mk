################################################################################
#
# libxmlpp
#
################################################################################

LIBXMLPP_VERSION_MAJOR = 2.34
LIBXMLPP_VERSION = $(LIBXMLPP_VERSION_MAJOR).2
LIBXMLPP_LICENSE = LGPLv2.1 (library), LGPLv2+ (examples)
LIBXMLPP_LICENSE_FILES = COPYING
LIBXMLPP_SOURCE = libxml++-$(LIBXMLPP_VERSION).tar.xz
LIBXMLPP_SITE = http://ftp.gnome.org/pub/GNOME/sources/libxml++/$(LIBXMLPP_VERSION_MAJOR)
LIBXMLPP_INSTALL_STAGING = YES
LIBXMLPP_DEPENDENCIES = libxml2 glibmm host-pkgconf

$(eval $(autotools-package))
