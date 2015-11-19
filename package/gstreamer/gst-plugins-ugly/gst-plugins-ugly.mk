################################################################################
#
# gst-plugins-ugly
#
################################################################################

GST_PLUGINS_UGLY_VERSION = 0.10.19
GST_PLUGINS_UGLY_SOURCE = gst-plugins-ugly-$(GST_PLUGINS_UGLY_VERSION).tar.xz
GST_PLUGINS_UGLY_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-ugly
# COPYING is in fact LGPLv2.1, but all of the code is v2+
# (except for one test, xingmux)
GST_PLUGINS_UGLY_LICENSE = LGPLv2+, GPLv2+ (synaesthesia)
GST_PLUGINS_UGLY_LICENSE_FILES = COPYING

GST_PLUGINS_UGLY_CONF_OPTS = \
	--disable-examples

GST_PLUGINS_UGLY_DEPENDENCIES = gstreamer gst-plugins-base

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_ASFDEMUX),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-asfdemux
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-asfdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_DVDLPCMDEC),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-dvdlpcmdec
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-dvdlpcmdec
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_DVDSUB),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-dvdsub
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-dvdsub
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_IEC958),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-iec958
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-iec958
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MPEGAUDIOPARSE),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-mpegaudioparse
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-mpegaudioparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MPEGSTREAM),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-mpegstream
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-mpegstream
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_REALMEDIA),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-realmedia
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-realmedia
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_SYNAESTHESIA),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-synaesthesia
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-synaesthesia
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_LAME),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-lame
GST_PLUGINS_UGLY_DEPENDENCIES += lame
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-lame
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MAD),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-mad
GST_PLUGINS_UGLY_DEPENDENCIES += libid3tag libmad
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-mad
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MPEG2DEC),y)
GST_PLUGINS_UGLY_CONF_OPTS += --enable-mpeg2dec
GST_PLUGINS_UGLY_DEPENDENCIES += libmpeg2
else
GST_PLUGINS_UGLY_CONF_OPTS += --disable-mpeg2dec
endif

$(eval $(autotools-package))
