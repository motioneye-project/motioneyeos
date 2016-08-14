################################################################################
#
# gupnp-av
#
################################################################################

GUPNP_AV_VERSION_MAJOR = 0.12
GUPNP_AV_VERSION = $(GUPNP_AV_VERSION_MAJOR).8
GUPNP_AV_SOURCE = gupnp-av-$(GUPNP_AV_VERSION).tar.xz
GUPNP_AV_SITE = http://ftp.gnome.org/pub/gnome/sources/gupnp-av/$(GUPNP_AV_VERSION_MAJOR)
GUPNP_AV_LICENSE = LGPLv2+
GUPNP_AV_LICENSE_FILES = COPYING
GUPNP_AV_INSTALL_STAGING = YES
GUPNP_AV_DEPENDENCIES = host-pkgconf libglib2 libxml2 gupnp

$(eval $(autotools-package))
