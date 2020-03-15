################################################################################
#
# gupnp
#
################################################################################

GUPNP_VERSION_MAJOR = 1.0
GUPNP_VERSION = $(GUPNP_VERSION_MAJOR).4
GUPNP_SOURCE = gupnp-$(GUPNP_VERSION).tar.xz
GUPNP_SITE = http://ftp.gnome.org/pub/gnome/sources/gupnp/$(GUPNP_VERSION_MAJOR)
GUPNP_LICENSE = LGPL-2.0+
GUPNP_LICENSE_FILES = COPYING
GUPNP_INSTALL_STAGING = YES
GUPNP_DEPENDENCIES = host-pkgconf libglib2 libxml2 gssdp util-linux

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GUPNP_CONF_OPTS += --enable-introspection
GUPNP_DEPENDENCIES += gobject-introspection
else
GUPNP_CONF_OPTS += --disable-introspection
endif

$(eval $(autotools-package))
