################################################################################
#
# xbmc
#
################################################################################

XBMC_VERSION = 13.2-Gotham
XBMC_SOURCE = $(XBMC_VERSION).tar.gz
XBMC_SITE = https://github.com/xbmc/xbmc/archive
XBMC_LICENSE = GPLv2
XBMC_LICENSE_FILES = LICENSE.GPL
# XBMC needs host-sdl_image (and therefore host-sdl) for a host tools it builds
# called TexturePacker. It is responsible to take all the images used in the
# GUI and pack them in a blob.
# http://wiki.xbmc.org/index.php?title=TexturePacker
XBMC_DEPENDENCIES = host-gawk host-gettext host-gperf host-infozip host-lzo host-sdl_image host-swig
XBMC_DEPENDENCIES += boost bzip2 expat flac fontconfig freetype jasper jpeg \
	libass libcdio libcurl libfribidi libgcrypt libmad libmodplug libmpeg2 \
	libogg libplist libpng libsamplerate libungif libvorbis libxml2 libxslt lzo ncurses \
	openssl pcre python readline sqlite taglib tiff tinyxml yajl zlib

# xbmc@i386 depends on nasm
XBMC_DEPENDENCIES += $(if $(BR2_i386),host-nasm)

# ffmpeg depends on yasm on MMX archs
# xbmc configure passes $(BR2_ARCH) to ffmpeg configure which adds
# yasm as dependency for x86_64, even if BR2_x86_generic=y
ifneq ($(BR2_X86_CPU_HAS_MMX)$(BR2_x86_64),)
XBMC_DEPENDENCIES += host-yasm
endif

XBMC_CONF_ENV = \
	PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)" \
	PYTHON_LDFLAGS="-lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm" \
	PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)" \
	PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	PYTHON_NOVERSIONCHECK="no-check" \
	use_texturepacker_native=yes \
	USE_TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr" \
	TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"

XBMC_CONF_OPTS +=  \
	--with-arch=$(BR2_ARCH) \
	--disable-crystalhd \
	--disable-dvdcss \
	--disable-hal \
	--disable-joystick \
	--disable-mysql \
	--disable-openmax \
	--disable-optical-drive \
	--disable-projectm \
	--disable-pulse \
	--disable-ssh \
	--disable-vdpau \
	--disable-vtbdecoder \
	--enable-optimizations

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
XBMC_DEPENDENCIES += rpi-userland
XBMC_CONF_OPTS += --with-platform=raspberry-pi --enable-player=omxplayer
XBMC_CONF_ENV += INCLUDES="-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux" \
	LIBS="-lvcos -lvchostif"
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
XBMC_CONF_OPTS += --enable-libcap
XBMC_DEPENDENCIES += libcap
else
XBMC_CONF_OPTS += --disable-libcap
endif

ifeq ($(BR2_PACKAGE_XBMC_DBUS),y)
XBMC_DEPENDENCIES += dbus
XBMC_CONF_OPTS += --enable-dbus
else
XBMC_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_XBMC_ALSA_LIB),y)
XBMC_DEPENDENCIES += alsa-lib
XBMC_CONF_OPTS += --enable-alsa
else
XBMC_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_LAME),y)
XBMC_DEPENDENCIES += lame
XBMC_CONF_OPTS += --enable-libmp3lame
else
XBMC_CONF_OPTS += --disable-libmp3lame
endif

# quote from xbmc/configure.in: "GLES overwrites GL if both set to yes."
# we choose the opposite because opengl offers more features, like libva support
ifeq ($(BR2_PACKAGE_XBMC_GL),y)
XBMC_DEPENDENCIES += libglew libglu libgl sdl_image xlib_libX11 xlib_libXext \
	xlib_libXmu xlib_libXrandr xlib_libXt
XBMC_CONF_OPTS += --enable-gl --enable-sdl --enable-x11 --enable-xrandr --disable-gles
ifeq ($(BR2_PACKAGE_XBMC_RSXS),y)
# fix rsxs compile
# make sure target libpng-config is used, options taken from rsxs-0.9/acinclude.m4
XBMC_CONF_ENV += \
	jm_cv_func_gettimeofday_clobber=no \
	mac_cv_pkg_png=$(STAGING_DIR)/usr/bin/libpng-config \
	mac_cv_pkg_cppflags="`$(STAGING_DIR)/usr/bin/libpng-config --I_opts --cppflags`" \
	mac_cv_pkg_cxxflags="`$(STAGING_DIR)/usr/bin/libpng-config --ccopts`" \
	mac_cv_pkg_ldflags="`$(STAGING_DIR)/usr/bin/libpng-config --L_opts --R_opts`" \
	mac_cv_pkg_libs="`$(STAGING_DIR)/usr/bin/libpng-config --libs`"
XBMC_CONF_OPTS += --enable-rsxs
else
XBMC_CONF_OPTS += --disable-rsxs
endif
else
XBMC_CONF_OPTS += --disable-gl --disable-rsxs --disable-sdl --disable-x11 --disable-xrandr
ifeq ($(BR2_PACKAGE_XBMC_EGL_GLES),y)
XBMC_DEPENDENCIES += libegl libgles
XBMC_CONF_OPTS += --enable-gles
else
XBMC_CONF_OPTS += --disable-gles
endif
endif

ifeq ($(BR2_PACKAGE_XBMC_GOOM),y)
XBMC_CONF_OPTS += --enable-goom
else
XBMC_CONF_OPTS += --disable-goom
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBUSB),y)
XBMC_DEPENDENCIES += libusb-compat
XBMC_CONF_OPTS += --enable-libusb
else
XBMC_CONF_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBMICROHTTPD),y)
XBMC_DEPENDENCIES += libmicrohttpd
XBMC_CONF_OPTS += --enable-webserver
else
XBMC_CONF_OPTS += --disable-webserver
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBSMBCLIENT),y)
XBMC_DEPENDENCIES += samba
XBMC_CONF_OPTS += --enable-samba
else
XBMC_CONF_OPTS += --disable-samba
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBNFS),y)
XBMC_DEPENDENCIES += libnfs
XBMC_CONF_OPTS += --enable-nfs
else
XBMC_CONF_OPTS += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_XBMC_RTMPDUMP),y)
XBMC_DEPENDENCIES += rtmpdump
XBMC_CONF_OPTS += --enable-rtmp
else
XBMC_CONF_OPTS += --disable-rtmp
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBBLURAY),y)
XBMC_DEPENDENCIES += libbluray
XBMC_CONF_OPTS += --enable-libbluray
else
XBMC_CONF_OPTS += --disable-libbluray
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBSHAIRPLAY),y)
XBMC_DEPENDENCIES += libshairplay
XBMC_CONF_OPTS += --enable-airplay
else
XBMC_CONF_OPTS += --disable-airplay
endif

ifeq ($(BR2_PACKAGE_XBMC_AVAHI),y)
XBMC_DEPENDENCIES += avahi
XBMC_CONF_OPTS += --enable-avahi
else
XBMC_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBCEC),y)
XBMC_DEPENDENCIES += libcec
XBMC_CONF_OPTS += --enable-libcec
else
XBMC_CONF_OPTS += --disable-libcec
endif

ifeq ($(BR2_PACKAGE_XBMC_WAVPACK),y)
XBMC_DEPENDENCIES += wavpack
endif

ifeq ($(BR2_PACKAGE_XBMC_LIBTHEORA),y)
XBMC_DEPENDENCIES += libtheora
endif

# xbmc needs libva & libva-glx
ifeq ($(BR2_PACKAGE_XBMC_LIBVA)$(BR2_PACKAGE_MESA3D_DRI_DRIVER),yy)
XBMC_DEPENDENCIES += mesa3d libva
XBMC_CONF_OPTS += --enable-vaapi
else
XBMC_CONF_OPTS += --disable-vaapi
endif

# Add HOST_DIR to PATH for codegenerator.mk to find swig
define XBMC_BOOTSTRAP
	cd $(@D) && PATH=$(BR_PATH) ./bootstrap
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
