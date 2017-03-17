################################################################################
#
# gupnp-tools
#
################################################################################

GUPNP_TOOLS_VERSION_MAJOR = 0.8
GUPNP_TOOLS_VERSION = $(GUPNP_TOOLS_VERSION_MAJOR).13
GUPNP_TOOLS_SOURCE = gupnp-tools-$(GUPNP_TOOLS_VERSION).tar.xz
GUPNP_TOOLS_SITE = \
	http://ftp.gnome.org/pub/gnome/sources/gupnp-tools/$(GUPNP_TOOLS_VERSION_MAJOR)
GUPNP_TOOLS_LICENSE = GPLv2+
GUPNP_TOOLS_LICENSE_FILES = COPYING
GUPNP_TOOLS_INSTALL_STAGING = YES
GUPNP_TOOLS_DEPENDENCIES = \
	host-pkgconf \
	libglib2 \
	libxml2 \
	gssdp \
	gupnp \
	libsoup \
	libgtk3

ifeq ($(BR2_PACKAGE_GUPNP_AV),y)
GUPNP_TOOLS_CONF_OPTS += --with-av
GUPNP_TOOLS_DEPENDENCIES += gupnp-av
else
GUPNP_TOOLS_CONF_OPTS += --without-av
endif

ifeq ($(BR2_PACKAGE_GTKSOURCEVIEW),y)
GUPNP_TOOLS_DEPENDENCIES += gtksourceview
endif

$(eval $(autotools-package))
