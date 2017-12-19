################################################################################
#
# gst1-plugins-ugly
#
################################################################################

GST1_PLUGINS_UGLY_VERSION = 1.12.3
GST1_PLUGINS_UGLY_SOURCE = gst-plugins-ugly-$(GST1_PLUGINS_UGLY_VERSION).tar.xz
GST1_PLUGINS_UGLY_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-ugly
GST1_PLUGINS_UGLY_LICENSE_FILES = COPYING
# GPL licensed plugins will append to GST1_PLUGINS_UGLY_LICENSE if enabled.
GST1_PLUGINS_UGLY_LICENSE = LGPL-2.1+

GST1_PLUGINS_UGLY_CONF_OPTS = --disable-examples --disable-valgrind

GST1_PLUGINS_UGLY_CONF_OPTS += \
	--disable-a52dec \
	--disable-amrnb \
	--disable-amrwb \
	--disable-cdio \
	--disable-sidplay \
	--disable-twolame

GST1_PLUGINS_UGLY_DEPENDENCIES = gstreamer1 gst1-plugins-base

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-orc
GST1_PLUGINS_UGLY_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_ASFDEMUX),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-asfdemux
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-asfdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_DVDLPCMDEC),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-dvdlpcmdec
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-dvdlpcmdec
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_DVDSUB),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-dvdsub
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-dvdsub
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_UGL1_PLUGIN_XINGMUX),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-xingmux
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-xingmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_REALMEDIA),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-realmedia
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-realmedia
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_DVDREAD),y)
# configure does not use pkg-config to detect libdvdread
ifeq ($(BR2_PACKAGE_LIBDVDCSS)$(BR2_STATIC_LIBS),yy)
GST1_PLUGINS_UGLY_CONF_ENV += LIBS="-ldvdcss"
endif
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-dvdread
GST1_PLUGINS_UGLY_DEPENDENCIES += libdvdread
GST1_PLUGINS_UGLY_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-dvdread
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_LAME),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-lame
GST1_PLUGINS_UGLY_DEPENDENCIES += lame
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-lame
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_MPG123),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-mpg123
GST1_PLUGINS_UGLY_DEPENDENCIES += mpg123
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_MPEG2DEC),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-mpeg2dec
GST1_PLUGINS_UGLY_DEPENDENCIES += libmpeg2
GST1_PLUGINS_UGLY_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-mpeg2dec
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_UGLY_PLUGIN_X264),y)
GST1_PLUGINS_UGLY_CONF_OPTS += --enable-x264
GST1_PLUGINS_UGLY_DEPENDENCIES += x264
GST1_PLUGINS_UGLY_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_UGLY_CONF_OPTS += --disable-x264
endif

# Add GPL license if GPL plugins enabled.
ifeq ($(GST1_PLUGINS_UGLY_HAS_GPL_LICENSE),y)
GST1_PLUGINS_UGLY_LICENSE += GPL-2.0
endif

# Use the following command to extract license info for plugins.
# # find . -name 'plugin-*.xml' | xargs grep license

$(eval $(autotools-package))
