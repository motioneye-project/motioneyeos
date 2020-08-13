################################################################################
#
# gst1-libav
#
################################################################################

GST1_LIBAV_VERSION = 1.16.2
GST1_LIBAV_SOURCE = gst-libav-$(GST1_LIBAV_VERSION).tar.xz
GST1_LIBAV_SITE = https://gstreamer.freedesktop.org/src/gst-libav

GST1_LIBAV_DEPENDENCIES = \
	host-pkgconf ffmpeg gstreamer1 gst1-plugins-base \
	$(if $(BR2_PACKAGE_BZIP2),bzip2) \
	$(if $(BR2_PACKAGE_XZ),xz)
GST1_LIBAV_LICENSE = GPL-2.0+
GST1_LIBAV_LICENSE_FILES = COPYING
GST1_LIBAV_CONF_EXTRA_OPTS = --cross-prefix=$(TARGET_CROSS) --target-os=linux

# fixes arm build: https://bugzilla.gnome.org/show_bug.cgi?id=694416
ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_aarch64)$(BR2_aarch64_be),y)
GST1_LIBAV_CONF_ENV = AS="$(TARGET_CROSS)gcc"
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-zlib
GST1_LIBAV_DEPENDENCIES += zlib
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GST1_LIBAV_CONF_EXTRA_OPTS += --enable-bzlib
GST1_LIBAV_DEPENDENCIES += bzip2
else
GST1_LIBAV_CONF_EXTRA_OPTS += --disable-bzlib
endif

GST1_LIBAV_CONF_OPTS = \
	--with-system-libav \
	--with-libav-extra-configure="$(GST1_LIBAV_CONF_EXTRA_OPTS)"

$(eval $(autotools-package))
