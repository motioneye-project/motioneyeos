################################################################################
#
# kodi
#
################################################################################

KODI_VERSION = 16.1-Jarvis
KODI_SITE = $(call github,xbmc,xbmc,$(KODI_VERSION))
KODI_LICENSE = GPLv2
KODI_LICENSE_FILES = LICENSE.GPL
# needed for binary addons
KODI_INSTALL_STAGING = YES
KODI_DEPENDENCIES = host-gawk host-gettext host-gperf host-zip host-giflib \
	host-libjpeg host-lzo host-nasm host-libpng host-swig
KODI_DEPENDENCIES += boost bzip2 expat ffmpeg fontconfig freetype giflib jasper jpeg \
	libass libcdio libcrossguid libcurl libdcadec libfribidi libgcrypt libmpeg2 \
	libogg libplist libpng libsamplerate libsquish libvorbis libxml2 \
	libxslt lzo ncurses openssl pcre python readline sqlite taglib tiff \
	tinyxml yajl zlib

KODI_CONF_ENV = \
	PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)" \
	PYTHON_LDFLAGS="-lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm" \
	PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)" \
	PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	PYTHON_NOVERSIONCHECK="no-check" \
	use_texturepacker_native=yes \
	USE_TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr" \
	TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"

KODI_CONF_OPTS +=  \
	--with-ffmpeg=shared \
	--disable-joystick \
	--disable-openmax \
	--disable-pulse \
	--disable-vdpau \
	--disable-vtbdecoder \
	--enable-optimizations

ifeq ($(BR2_PACKAGE_MYSQL),y)
KODI_CONF_OPTS += --enable-mysql
KODI_CONF_ENV += ac_cv_path_MYSQL_CONFIG="$(STAGING_DIR)/usr/bin/mysql_config"
KODI_DEPENDENCIES += mysql
else
KODI_CONF_OPTS += --disable-mysql
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
KODI_DEPENDENCIES += rpi-userland
# Kodi has specific configuration flags for RPi/RPi2. Configure for a
# RPi2 when we're sure, fallback to RPi otherwise.
ifeq ($(BR2_cortex_a7),y)
KODI_CONF_OPTS += --with-platform=raspberry-pi2
else
KODI_CONF_OPTS += --with-platform=raspberry-pi
endif
KODI_CONF_OPTS += --enable-player=omxplayer
KODI_CONF_ENV += INCLUDES="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux" \
	LIBS="-lvcos -lvchostif"
endif

ifeq ($(BR2_PACKAGE_LIBFSLVPUWRAP),y)
KODI_DEPENDENCIES += libfslvpuwrap
KODI_CONF_OPTS += --enable-codec=imxvpu
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
KODI_CONF_OPTS += --enable-libcap
KODI_DEPENDENCIES += libcap
else
KODI_CONF_OPTS += --disable-libcap
endif

ifeq ($(BR2_PACKAGE_KODI_DBUS),y)
KODI_DEPENDENCIES += dbus
KODI_CONF_OPTS += --enable-dbus
else
KODI_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_KODI_ALSA_LIB),y)
KODI_DEPENDENCIES += alsa-lib
KODI_CONF_OPTS += --enable-alsa
else
KODI_CONF_OPTS += --disable-alsa
endif

# quote from kodi/configure.in: "GLES overwrites GL if both set to yes."
# we choose the opposite because opengl offers more features, like libva support
# GL means X11, and under X11, Kodi needs libdrm; libdrm is forcefully selected
# by a modular Xorg server, which Kodi already depends on.
ifeq ($(BR2_PACKAGE_KODI_GL),y)
KODI_DEPENDENCIES += libglew libglu libgl xlib_libX11 xlib_libXext \
	xlib_libXmu xlib_libXrandr xlib_libXt libdrm
KODI_CONF_OPTS += --enable-gl --enable-x11 --disable-gles
else
KODI_CONF_OPTS += --disable-gl --disable-x11
ifeq ($(BR2_PACKAGE_KODI_EGL_GLES),y)
KODI_DEPENDENCIES += libegl libgles
KODI_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags --libs egl`"
KODI_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags --libs egl`"
KODI_CONF_OPTS += --enable-gles
else
KODI_CONF_OPTS += --disable-gles
endif
endif

ifeq ($(BR2_PACKAGE_KODI_LIBUSB),y)
KODI_DEPENDENCIES += libusb-compat
KODI_CONF_OPTS += --enable-libusb
else
KODI_CONF_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_KODI_LIBMICROHTTPD),y)
KODI_DEPENDENCIES += libmicrohttpd
KODI_CONF_OPTS += --enable-webserver
else
KODI_CONF_OPTS += --disable-webserver
endif

ifeq ($(BR2_PACKAGE_KODI_LIBSMBCLIENT),y)
KODI_DEPENDENCIES += samba4
KODI_CONF_OPTS += --enable-samba
else
KODI_CONF_OPTS += --disable-samba
endif

ifeq ($(BR2_PACKAGE_KODI_LIBNFS),y)
KODI_DEPENDENCIES += libnfs
KODI_CONF_OPTS += --enable-nfs
else
KODI_CONF_OPTS += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_KODI_RTMPDUMP),y)
KODI_DEPENDENCIES += rtmpdump
KODI_CONF_OPTS += --enable-rtmp
else
KODI_CONF_OPTS += --disable-rtmp
endif

ifeq ($(BR2_PACKAGE_KODI_LIBBLURAY),y)
KODI_DEPENDENCIES += libbluray
KODI_CONF_OPTS += --enable-libbluray
else
KODI_CONF_OPTS += --disable-libbluray
endif

ifeq ($(BR2_PACKAGE_KODI_LIBSHAIRPLAY),y)
KODI_DEPENDENCIES += libshairplay
KODI_CONF_OPTS += --enable-airplay
else
KODI_CONF_OPTS += --disable-airplay
endif

ifeq ($(BR2_PACKAGE_KODI_LIBSSH),y)
KODI_DEPENDENCIES += libssh
KODI_CONF_OPTS += --enable-ssh
else
KODI_CONF_OPTS += --disable-ssh
endif

ifeq ($(BR2_PACKAGE_KODI_AVAHI),y)
KODI_DEPENDENCIES += avahi
KODI_CONF_OPTS += --enable-avahi
else
KODI_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_KODI_LIBCEC),y)
KODI_DEPENDENCIES += libcec
KODI_CONF_OPTS += --enable-libcec
else
KODI_CONF_OPTS += --disable-libcec
endif

ifeq ($(BR2_PACKAGE_KODI_LIRC),y)
KODI_CONF_OPTS += --enable-lirc
else
KODI_CONF_OPTS += --disable-lirc
endif

ifeq ($(BR2_PACKAGE_KODI_LIBTHEORA),y)
KODI_DEPENDENCIES += libtheora
endif

# kodi needs libva & libva-glx
ifeq ($(BR2_PACKAGE_KODI_LIBVA)$(BR2_PACKAGE_MESA3D_DRI_DRIVER),yy)
KODI_DEPENDENCIES += mesa3d libva
KODI_CONF_OPTS += --enable-vaapi
else
KODI_CONF_OPTS += --disable-vaapi
endif

ifeq ($(BR2_PACKAGE_KODI_OPTICALDRIVE),y)
KODI_CONF_OPTS += --enable-optical-drive --enable-dvdcss
else
KODI_CONF_OPTS += --disable-optical-drive --disable-dvdcss
endif

# Add HOST_DIR to PATH for codegenerator.mk to find swig
define KODI_BOOTSTRAP
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)/tools/depends/native/JsonSchemaBuilder
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)/tools/depends/native/TexturePacker
	cd $(@D) && PATH=$(BR_PATH) ./bootstrap
endef
KODI_PRE_CONFIGURE_HOOKS += KODI_BOOTSTRAP

define KODI_CLEAN_UNUSED_ADDONS
	rm -Rf $(TARGET_DIR)/usr/share/kodi/addons/visualization.milkdrop
	rm -Rf $(TARGET_DIR)/usr/share/kodi/addons/visualization.projectm
	rm -Rf $(TARGET_DIR)/usr/share/kodi/addons/visualization.itunes
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_CLEAN_UNUSED_ADDONS

define KODI_CLEAN_CONFLUENCE_SKIN
	find $(TARGET_DIR)/usr/share/kodi/addons/skin.confluence/media -name *.png -delete
	find $(TARGET_DIR)/usr/share/kodi/addons/skin.confluence/media -name *.jpg -delete
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_CLEAN_CONFLUENCE_SKIN

define KODI_INSTALL_BR_WRAPPER
	$(INSTALL) -D -m 0755 package/kodi/br-kodi \
		$(TARGET_DIR)/usr/bin/br-kodi
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_BR_WRAPPER

# When run from a startup script, Kodi has no $HOME where to store its
# configuration, so ends up storing it in /.kodi  (yes, at the root of
# the rootfs). This is a problem for read-only filesystems. But we can't
# easily change that, so create /.kodi as a symlink where we want the
# config to eventually be. Add synlinks for the legacy XBMC name as well
define KODI_INSTALL_CONFIG_DIR
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/kodi
	ln -sf /var/kodi $(TARGET_DIR)/.kodi
	ln -sf /var/kodi $(TARGET_DIR)/var/xbmc
	ln -sf /var/kodi $(TARGET_DIR)/.xbmc
endef
KODI_POST_INSTALL_TARGET_HOOKS += KODI_INSTALL_CONFIG_DIR

define KODI_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/kodi/S50kodi \
		$(TARGET_DIR)/etc/init.d/S50kodi
endef

define KODI_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/kodi/kodi.service \
		$(TARGET_DIR)/usr/lib/systemd/system/kodi.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/kodi.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/kodi.service
endef

$(eval $(autotools-package))
