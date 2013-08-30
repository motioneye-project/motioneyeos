################################################################################
#
# gst-plugins-ugly
#
################################################################################

GST_PLUGINS_UGLY_VERSION = 0.10.19
GST_PLUGINS_UGLY_SOURCE = gst-plugins-ugly-$(GST_PLUGINS_UGLY_VERSION).tar.bz2
GST_PLUGINS_UGLY_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-ugly

GST_PLUGINS_UGLY_CONF_OPT = \
		--disable-examples

GST_PLUGINS_UGLY_DEPENDENCIES = gstreamer gst-plugins-base

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_ASFDEMUX),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-asfdemux
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-asfdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_DVDLPCMDEC),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-dvdlpcmdec
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-dvdlpcmdec
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_DVDSUB),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-dvdsub
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-dvdsub
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_IEC958),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-iec958
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-iec958
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MPEGAUDIOPARSE),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-mpegaudioparse
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-mpegaudioparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MPEGSTREAM),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-mpegstream
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-mpegstream
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_REALMEDIA),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-realmedia
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-realmedia
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_SYNAESTHESIA),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-synaesthesia
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-synaesthesia
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_LAME),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-lame
GST_PLUGINS_UGLY_DEPENDENCIES += lame
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-lame
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MAD),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-mad
GST_PLUGINS_UGLY_DEPENDENCIES += libid3tag libmad
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-mad
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGLY_PLUGIN_MPEG2DEC),y)
GST_PLUGINS_UGLY_CONF_OPT += --enable-mpeg2dec
GST_PLUGINS_UGLY_DEPENDENCIES += libmpeg2
else
GST_PLUGINS_UGLY_CONF_OPT += --disable-mpeg2dec
endif

$(eval $(autotools-package))
