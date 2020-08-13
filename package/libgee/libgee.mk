################################################################################
#
# libgee
#
################################################################################

LIBGEE_VERSION_MAJOR = 0.20
LIBGEE_VERSION = $(LIBGEE_VERSION_MAJOR).3
LIBGEE_SITE = http://ftp.gnome.org/pub/gnome/sources/libgee/$(LIBGEE_VERSION_MAJOR)
LIBGEE_SOURCE = libgee-$(LIBGEE_VERSION).tar.xz
LIBGEE_DEPENDENCIES = host-pkgconf host-vala libglib2
LIBGEE_INSTALL_STAGING = YES
LIBGEE_LICENSE = LGPL-2.1+
LIBGEE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBGEE_CONF_OPTS += --enable-introspection
LIBGEE_DEPENDENCIES += gobject-introspection
else
LIBGEE_CONF_OPTS += --disable-introspection
endif

$(eval $(autotools-package))
