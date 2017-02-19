################################################################################
#
# gupnp-dlna
#
################################################################################

GUPNP_DLNA_VERSION_MAJOR = 0.10
GUPNP_DLNA_VERSION = $(GUPNP_DLNA_VERSION_MAJOR).5
GUPNP_DLNA_SOURCE = gupnp-dlna-$(GUPNP_DLNA_VERSION).tar.xz
GUPNP_DLNA_SITE = \
	http://ftp.gnome.org/pub/gnome/sources/gupnp-dlna/$(GUPNP_DLNA_VERSION_MAJOR)
# COPYING contains LGPLv2.1 but all source files contain LPGLv2+
GUPNP_DLNA_LICENSE = LGPLv2+
GUPNP_DLNA_LICENSE_FILES = COPYING
GUPNP_DLNA_INSTALL_STAGING = YES
GUPNP_DLNA_DEPENDENCIES = host-pkgconf libglib2 libxml2

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE),y)
GUPNP_DLNA_CONF_OPTS += --enable-legacy-gstreamer-metadata-backend
GUPNP_DLNA_DEPENDENCIES += gstreamer gst-plugins-base
else
GUPNP_DLNA_CONF_OPTS += --disable-legacy-gstreamer-metadata-backend
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
GUPNP_DLNA_CONF_OPTS += --enable-gstreamer-metadata-backend
GUPNP_DLNA_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
GUPNP_DLNA_CONF_OPTS += --disable-gstreamer-metadata-backend
endif

$(eval $(autotools-package))
