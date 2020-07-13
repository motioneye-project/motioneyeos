################################################################################
#
# gupnp
#
################################################################################

GUPNP_VERSION_MAJOR = 1.2
GUPNP_VERSION = $(GUPNP_VERSION_MAJOR).3
GUPNP_SOURCE = gupnp-$(GUPNP_VERSION).tar.xz
GUPNP_SITE = http://ftp.gnome.org/pub/gnome/sources/gupnp/$(GUPNP_VERSION_MAJOR)
GUPNP_LICENSE = LGPL-2.0+
GUPNP_LICENSE_FILES = COPYING
GUPNP_INSTALL_STAGING = YES
GUPNP_DEPENDENCIES = host-pkgconf libglib2 libxml2 gssdp util-linux
GUPNP_CONF_OPTS = -Dexamples=false

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GUPNP_CONF_OPTS += -Dintrospection=true -Dvapi=true
GUPNP_DEPENDENCIES += host-vala gobject-introspection
else
GUPNP_CONF_OPTS += -Dintrospection=false -Dvapi=false
endif

$(eval $(meson-package))
