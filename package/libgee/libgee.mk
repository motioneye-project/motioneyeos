################################################################################
#
# libgee
#
################################################################################

LIBGEE_VERSION_MAJOR = 0.20
LIBGEE_VERSION = $(LIBGEE_VERSION_MAJOR).2
LIBGEE_SITE = http://ftp.gnome.org/pub/gnome/sources/libgee/$(LIBGEE_VERSION_MAJOR)
LIBGEE_SOURCE = libgee-$(LIBGEE_VERSION).tar.xz
LIBGEE_DEPENDENCIES = host-pkgconf host-vala libglib2
LIBGEE_INSTALL_STAGING = YES
LIBGEE_LICENSE = LGPL-2.1+
LIBGEE_LICENSE_FILES = COPYING

$(eval $(autotools-package))
