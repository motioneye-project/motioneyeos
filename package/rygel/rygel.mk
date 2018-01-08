################################################################################
#
# rygel
#
################################################################################

RYGEL_VERSION_MAJOR = 0.36
RYGEL_VERSION = $(RYGEL_VERSION_MAJOR).0
RYGEL_SOURCE = rygel-$(RYGEL_VERSION).tar.xz
RYGEL_SITE = http://ftp.gnome.org/pub/gnome/sources/rygel/$(RYGEL_VERSION_MAJOR)
RYGEL_LICENSE = LGPL-2.1+, CC-BY-SA-3.0 (logo)
RYGEL_LICENSE_FILES = COPYING COPYING.logo
RYGEL_DEPENDENCIES = \
	gupnp-av \
	libgee \
	libmediaart \
	sqlite
RYGEL_INSTALL_STAGING = YES
# We're patching configure.ac
RYGEL_AUTORECONF = YES

RYGEL_CONF_OPTS += \
	--disable-apidocs \
	--disable-coverage \
	--disable-example-plugins \
	--enable-external-plugin \
	--enable-lms-plugin \
	--enable-mpris-plugin \
	--enable-ruih-plugin \
	--disable-tracker-plugin

ifeq ($(BR2_PACKAGE_GDK_PIXBUF),y)
RYGEL_DEPENDENCIES += gdk-pixbuf
endif

ifeq ($(BR2_PACKAGE_RYGEL_MEDIA_ENGINE_GSTREAMER1),y)
RYGEL_CONF_OPTS += \
	--with-media-engine=gstreamer \
	--enable-playbin-plugin \
	--enable-media_export-plugin \
	--enable-gst-launch-plugin
RYGEL_DEPENDENCIES += \
	gupnp-dlna \
	gst1-plugins-base \
	gstreamer1
else ifeq ($(BR2_PACKAGE_RYGEL_MEDIA_ENGINE_SIMPLE),y)
RYGEL_CONF_OPTS += \
	--with-media-engine=simple \
	--disable-playbin-plugin \
	--disable-media_export-plugin \
	--disable-gst-launch-plugin
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
RYGEL_CONF_OPTS += --with-ui
RYGEL_DEPENDENCIES += libgtk3
else
RYGEL_CONF_OPTS += --without-ui
endif

define RYGEL_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/rygel/S99rygel \
		$(TARGET_DIR)/etc/init.d/S99rygel
endef

define RYGEL_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/rygel/rygel.service \
		$(TARGET_DIR)/usr/lib/systemd/system/rygel.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/rygel.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/rygel.service
endef

$(eval $(autotools-package))
