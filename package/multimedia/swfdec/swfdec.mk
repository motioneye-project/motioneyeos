#############################################################
#
# Swfdec
#
#############################################################
SWFDEC_VERSION_MAJOR = 0.8
SWFDEC_VERSION_MINOR = 4
SWFDEC_VERSION = $(SWFDEC_VERSION_MAJOR).$(SWFDEC_VERSION_MINOR)
SWFDEC_SOURCE = swfdec-$(SWFDEC_VERSION).tar.gz
SWFDEC_SITE = http://swfdec.freedesktop.org/download/swfdec/$(SWFDEC_VERSION_MAJOR)
SWFDEC_MAKE_OPT = \
	GLIB_MKENUMS=$(HOST_DIR)/usr/bin/glib-mkenums \
	GLIB_GENMARSHAL=$(HOST_DIR)/usr/bin/glib-genmarshal

SWFDEC_INSTALL_STAGING = YES
SWFDEC_INSTALL_TARGET = YES

SWFDEC_DEPENDENCIES = liboil alsa-lib pango cairo host-pkg-config

ifeq ($(BR2_PACKAGE_SWFDEC_GSTREAMER),y)
SWFDEC_DEPENDENCIES += gstreamer gst-plugins-base
else
SWFDEC_CONF_OPT += --disable-gstreamer
endif

ifeq ($(BR2_PACKAGE_SWFDEC_GTK_SUPPORT),y)
SWFDEC_DEPENDENCIES += libgtk2 libsoup
else
SWFDEC_CONF_OPT += --disable-gtk
endif

$(eval $(call AUTOTARGETS,package/multimedia,swfdec))

# swfdec uses glib-* at install time
# Notice: must come after AUTOTARGETS as that's where these variables gets set
SWFDEC_INSTALL_TARGET_OPT += $(SWFDEC_MAKE_OPT)
SWFDEC_INSTALL_STAGING_OPT += $(SWFDEC_MAKE_OPT)
