################################################################################
#
# xbmc
#
################################################################################

XBMC_VERSION = 12.3-Frodo
XBMC_SITE = $(call github,xbmc,xbmc,$(XBMC_VERSION))
XBMC_LICENSE = GPLv2
XBMC_LICENSE_FILES = LICENSE.GPL
# XBMC needs host-sdl_image (and therefore host-sdl) for a host tools it builds
# called TexturePacker. It is responsible to take all the images used in the
# GUI and pack them in a blob.
# http://wiki.xbmc.org/index.php?title=TexturePacker
XBMC_DEPENDENCIES = host-gawk host-gperf host-infozip host-lzo host-sdl_image host-swig
XBMC_DEPENDENCIES += boost bzip2 expat flac fontconfig freetype jasper jpeg \
	libass libcdio libcurl libegl libfribidi libgcrypt libgles libmad libmodplug libmpeg2 \
	libogg libplist libpng libsamplerate libungif libvorbis libxml2 lzo ncurses \
	openssl pcre python readline sqlite taglib tiff tinyxml yajl zlib

XBMC_CONF_ENV = \
	PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)" \
	PYTHON_LDFLAGS="-lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm" \
	PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)" \
	PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	PYTHON_NOVERSIONCHECK="no-check" \
	TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"

XBMC_CONF_OPT +=  \
	--disable-alsa \
	--disable-crystalhd \
	--disable-debug \
	--disable-dvdcss \
	--disable-gl \
	--disable-hal \
	--disable-joystick \
	--disable-mysql \
	--disable-openmax \
	--disable-optical-drive \
	--disable-projectm \
	--disable-pulse \
	--disable-sdl \
	--disable-ssh \
	--disable-vaapi \
	--disable-vdpau \
	--disable-vtbdecoder \
	--disable-x11 \
	--disable-xrandr \
	--enable-gles \
	--enable-optimizations

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
XBMC_DEPENDENCIES += rpi-userland
XBMC_CONF_OPT += --with-platform=raspberry-pi --enable-player=omxplayer
XBMC_CONF_ENV += INCLUDES="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
XBMC_DEPENDENCIES += dbus
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBUSB),y)
XBMC_DEPENDENCIES += libusb-compat
XBMC_CONF_OPT += --enable-libusb
else
XBMC_CONF_OPT += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBMICROHTTPD),y)
XBMC_DEPENDENCIES += libmicrohttpd
XBMC_CONF_OPT += --enable-webserver
else
XBMC_CONF_OPT += --disable-webserver
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBSMBCLIENT),y)
XBMC_DEPENDENCIES += samba
XBMC_CONF_OPT += --enable-samba
else
XBMC_CONF_OPT += --disable-samba
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBNFS),y)
XBMC_DEPENDENCIES += libnfs
XBMC_CONF_OPT += --enable-nfs
else
XBMC_CONF_OPT += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_XBMC_RTMPDUMP),y)
XBMC_DEPENDENCIES += rtmpdump
XBMC_CONF_OPT += --enable-rtmp
else
XBMC_CONF_OPT += --disable-rtmp
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBBLURAY),y)
XBMC_DEPENDENCIES += libbluray
XBMC_CONF_OPT += --enable-libbluray
else
XBMC_CONF_OPT += --disable-libbluray
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBSHAIRPLAY),y)
XBMC_DEPENDENCIES += libshairplay
XBMC_CONF_OPT += --enable-airplay
else
XBMC_CONF_OPT += --disable-airplay
endif

ifeq ($(BR2_PACKAGE_XBMC_AVAHI),y)
XBMC_DEPENDENCIES += avahi
XBMC_CONF_OPT += --enable-avahi
else
XBMC_CONF_OPT += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBCEC),y)
XBMC_DEPENDENCIES += libcec
XBMC_CONF_OPT += --enable-libcec
else
XBMC_CONF_OPT += --disable-libcec
endif

ifeq ($(BR2_PACKAGE_XBMC_WAVPACK),y)
XBMC_DEPENDENCIES += wavpack
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBTHEORA),y)
XBMC_DEPENDENCIES += libtheora
endif

# Add HOST_DIR to PATH for codegenerator.mk to find swig
define XBMC_BOOTSTRAP
	cd $(@D) && PATH=$(BR_PATH) AUTOPOINT=/bin/true ./bootstrap
endef
XBMC_PRE_CONFIGURE_HOOKS += XBMC_BOOTSTRAP

define XBMC_CLEAN_UNUSED_ADDONS
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/screensaver.rsxs.plasma
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.milkdrop
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.projectm
	rm -Rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.itunes
endef
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_UNUSED_ADDONS

define XBMC_CLEAN_CONFLUENCE_SKIN
	find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.png -delete
	find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.jpg -delete
endef
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_CONFLUENCE_SKIN

define XBMC_INSTALL_BR_WRAPPER
	$(INSTALL) -D -m 0755 package/xbmc/br-xbmc \
		$(TARGET_DIR)/usr/bin/br-xbmc
endef
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_BR_WRAPPER

# When run from a startup script, XBMC has no $HOME where to store its
# configuration, so ends up storing it in /.xbmc  (yes, at the root of
# the rootfs). This is a problem for read-only filesystems. But we can't
# easily change that, so create /.xbmc as a symlink where we want the
# config to eventually be.
define XBMC_INSTALL_CONFIG_DIR
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/xbmc
	ln -sf /var/xbmc $(TARGET_DIR)/.xbmc
endef
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_CONFIG_DIR

define XBMC_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/xbmc/S50xbmc \
		$(TARGET_DIR)/etc/init.d/S50xbmc
endef

define XBMC_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/xbmc/xbmc.service \
		$(TARGET_DIR)/etc/systemd/system/xbmc.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../xbmc.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/xbmc.service
endef

$(eval $(autotools-package))
