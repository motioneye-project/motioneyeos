CLASSPATH_VERSION = 0.98
CLASSPATH_SITE = $(BR2_GNU_MIRROR)/classpath
CLASSPATH_CONF_OPT = \
	--disable-examples \
	--disable-plugin \
	--disable-rpath \
	--disable-Werror \
	--disable-gconf-peer \
	--disable-tools

CLASSPATH_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
CLASSPATH_CONF_OPT += --enable-alsa
CLASSPATH_DEPENDENCIES += alsa-lib
else
CLASSPATH_CONF_OPT += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_GMP),y)
CLASSPATH_CONF_OPT += --enable-gmp
CLASSPATH_DEPENDENCIES += gmp
else
CLASSPATH_CONF_OPT += --disable-gmp
endif

ifeq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_XORG7),yy)
CLASSPATH_CONF_OPT += --enable-gtk-peer
CLASSPATH_DEPENDENCIES += libgtk2

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE),y)
CLASSPATH_CONF_OPT += --enable-gstreamer-peer
CLASSPATH_DEPENDENCIES += gst-plugins-base
else
CLASSPATH_CONF_OPT += --disable-gstreamer-peer
endif

else
CLASSPATH_CONF_OPT += --disable-gtk-peer --disable-gstreamer-peer
endif

ifeq ($(BR2_PACKAGE_QT),y)
CLASSPATH_CONF_OPT += --enable-qt-peer
CLASSPATH_DEPENDENCIES += qt
else
CLASSPATH_CONF_OPT += --disable-qt-peer
endif

ifeq ($(BR2_PACKAGE_LIBXML2)$(BR2_PACKAGE_LIBXSLT),yy)
CLASSPATH_CONF_OPT += --enable-xmlj
CLASSPATH_DEPENDENCIES += libxml2 libxslt
else
CLASSPATH_CONF_OPT += --disable-xmlj
endif

$(eval $(autotools-package))
