################################################################################
#
# gupnp
#
################################################################################

GUPNP_VERSION_MAJOR = 0.20
GUPNP_VERSION = $(GUPNP_VERSION_MAJOR).16
GUPNP_SOURCE = gupnp-$(GUPNP_VERSION).tar.xz
GUPNP_SITE = http://ftp.gnome.org/pub/gnome/sources/gupnp/$(GUPNP_VERSION_MAJOR)
GUPNP_LICENSE = LGPLv2+
GUPNP_LICENSE_FILES = COPYING
GUPNP_INSTALL_STAGING = YES
GUPNP_DEPENDENCIES = host-pkgconf libglib2 libxml2 gssdp util-linux

$(eval $(autotools-package))
