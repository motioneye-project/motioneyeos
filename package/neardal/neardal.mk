#############################################################
#
# neardal
#
#############################################################
NEARDAL_VERSION = 0.7
NEARDAL_SITE = http://github.com/connectivity/neardal/tarball/$(NEARDAL_VERSION)
NEARDAL_SOURCE = connectivity-neardal-$(NEARDAL_VERSION).tar.gz
NEARDAL_INSTALL_STAGING = YES
NEARDAL_LICENSE = GPLv2
NEARDAL_LICENSE_FILES = COPYING

NEARDAL_DEPENDENCIES = host-pkgconf dbus dbus-glib
NEARDAL_AUTORECONF = YES

$(eval $(autotools-package))
