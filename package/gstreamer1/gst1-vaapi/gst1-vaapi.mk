################################################################################
#
# gst1-vaapi
#
################################################################################

GST1_VAAPI_VERSION = 1.16.2
GST1_VAAPI_SITE = https://gstreamer.freedesktop.org/src/gstreamer-vaapi
GST1_VAAPI_SOURCE = gstreamer-vaapi-$(GST1_VAAPI_VERSION).tar.xz
GST1_VAAPI_LICENSE = LGPL-2.1+
GST1_VAAPI_LICENSE_FILES = COPYING.LIB

GST1_VAAPI_DEPENDENCIES += \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-bad \
	libva \
	libdrm

GST1_VAAPI_CONF_OPTS += \
	--disable-x11 \
	--disable-glx \
	--disable-wayland \
	--disable-egl \
	--disable-gtk-doc-html

ifeq ($(BR2_PACKAGE_GST1_VAAPI_ENCODERS),y)
GST1_VAAPI_CONF_OPTS += --enable-encoders
else
GST1_VAAPI_CONF_OPTS += --disable-encoders
endif

$(eval $(autotools-package))
