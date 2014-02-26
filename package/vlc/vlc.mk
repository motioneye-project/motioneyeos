################################################################################
#
# vlc
#
################################################################################

VLC_VERSION = 2.1.2
VLC_SITE = http://download.videolan.org/pub/videolan/vlc/$(VLC_VERSION)
VLC_SOURCE = vlc-$(VLC_VERSION).tar.xz
VLC_LICENSE = GPLv2+ LGPLv2.1+
VLC_LICENSE_FILES = COPYING COPYING.LIB
VLC_DEPENDENCIES = host-pkgconf
VLC_AUTORECONF = YES

VLC_CONF_OPT += \
	--disable-a52 \
	--without-shout \
	--without-twolame \
	--without-dca \
	--without-dirac \
	--without-schroedinger \
	--without-quicksync \
	--without-fluidsynth \
	--disable-zvbi \
	--without-kate \
	--without-caca \
	--disable-jack \
	--without-samplerate \
	--without-chromaprint \
	--without-goom \
	--disable-projectm \
	--disable-vsxu \
	--without-mtp \
	--without-opencv

# Building static and shared doesn't work, so force static off.
ifeq ($(BR2_PREFER_STATIC_LIB),)
VLC_CONF_OPT += --disable-static
endif

# Set powerpc altivec appropriately
ifeq ($(BR2_powerpc_7400)$(BR2_powerpc_7450)$(BR2_powerpc_970),y)
VCL_CONF_OPT += --enable-altivec
else
VLC_CONF_OPT += --disable-altivec
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
VLC_CONF_OPT += --enable-alsa
VLC_DEPENDENCIES += alsa-lib
else
VLC_CONF_OPT += --disable-alsa
endif

# bonjour support needs avahi-client, which needs avahi-daemon and dbus
ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_DBUS),yyy)
VLC_CONF_OPT += --with-bonjour
VLC_DEPENDENCIES += avahi dbus
else
VLC_CONF_OPT += --without-bonjour
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
VLC_CONF_OPT += --enable-dbus
VLC_DEPENDENCIES += dbus
else
VLC_CONF_OPT += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_DIRECTFB),y)
VLC_CONF_OPT += --enable-directfb
VLC_DEPENDENCIES += directfb
else
VLC_CONF_OPT += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_FAAD2),y)
VLC_CONF_OPT += --enable-faad
VLC_DEPENDENCIES += faad2
else
VLC_CONF_OPT += --disable-faad
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
VLC_CONF_OPT += --enable-avcodec
VLC_DEPENDENCIES += ffmpeg
else
VLC_CONF_OPT += --disable-avcodec
endif

ifeq ($(BR2_PACKAGE_FFMPEG_POSTPROC),y)
VLC_CONF_OPT += --enable-postproc
else
VLC_CONF_OPT += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
VLC_CONF_OPT += --enable-swscale
else
VLC_CONF_OPT += --disable-swscale
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
VLC_CONF_OPT += --with-flac
VLC_DEPENDENCIES += flac
else
VLC_CONF_OPT += --without-flac
endif

ifeq ($(BR2_PACKAGE_MESA3D),y)
VLC_CONF_OPT += --enable-glx
VLC_DEPENDENCIES += mesa3d
else
VLC_CONF_OPT += --disable-glx
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
VLC_CONF_OPT += --with-opus
VLC_DEPENDENCIES += opus
else
VLC_CONF_OPT += --without-opus
endif

ifeq ($(BR2_PACKAGE_LIBASS),y)
VLC_CONF_OPT += --enable-libass
VLC_DEPENDENCIES += libass
else
VLC_CONF_OPT += --disable-libass
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
VLC_CONF_OPT += --enable-libgcrypt
VLC_DEPENDENCIES += libgcrypt
VLC_CONF_ENV += \
	GCRYPT_CONFIG="$(STAGING_DIR)/usr/bin/libgcrypt-config"
else
VLC_CONF_OPT += --disable-libgcrypt
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
VLC_CONF_OPT += --enable-mad
VLC_DEPENDENCIES += libmad
else
VLC_CONF_OPT += --disable-mad
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
VLC_CONF_OPT += --enable-mod
VLC_DEPENDENCIES += libmodplug
else
VLC_CONF_OPT += --disable-mod
endif

ifeq ($(BR2_PACKAGE_LIBMPEG2),y)
VLC_CONF_OPT += --with-libmpeg2
VLC_DEPENDENCIES += libmpeg2
else
VLC_CONF_OPT += --without-libmpeg2
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
VLC_CONF_OPT += --enable-png
VLC_DEPENDENCIES += libpng
else
VLC_CONF_OPT += --disable-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
VLC_CONF_OPT += --with-svg
VLC_DEPENDENCIES += librsvg
else
VLC_CONF_OPT += --without-svg
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
VLC_CONF_OPT += --with-theora
VLC_DEPENDENCIES += libtheora
else
VLC_CONF_OPT += --without-theora
endif

ifeq ($(BR2_PACKAGE_LIBUPNP),y)
VLC_CONF_OPT += --with-upnp
VLC_DEPENDENCIES += libupnp
else
VLC_CONF_OPT += --without-upnp
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
VLC_CONF_OPT += --with-vorbis
VLC_DEPENDENCIES += libvorbis
else
VLC_CONF_OPT += --without-vorbis
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
VLC_CONF_OPT += --enable-v4l2
VLC_DEPENDENCIES += libv4l
else
VLC_CONF_OPT += --disable-v4l2
endif

ifeq ($(BR2_PACKAGE_LIBXCB),y)
VLC_CONF_OPT += --enable-xcb
VLC_DEPENDENCIES += libxcb
else
VLC_CONF_OPT += --disable-xcb
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
VLC_CONF_OPT += --with-libxml2
VLC_DEPENDENCIES += libxml2
else
VLC_CONF_OPT += --without-libxml2
endif

# live555 installs a static library only, and vlc tries to link it into a
# shared library - which doesn't work. So only enable live555 if static.
ifeq ($(BR2_PACKAGE_LIVE555)$(BR2_PREFER_STATIC_LIB),yy)
VLC_CONF_OPT += --enable-live555
VLC_DEPENDENCIES += live555
VLC_CONF_ENV += \
	LIVE555_CFLAGS="\
		-I$(STAGING_DIR)/usr/include/live \
		-I$(STAGING_DIR)/usr/include/live/BasicUsageEnvironment \
		-I$(STAGING_DIR)/usr/include/live/groupsock \
		-I$(STAGING_DIR)/usr/include/live/liveMedia \
		-I$(STAGING_DIR)/usr/include/live/UsageEnvironment \
		" \
	LIVE555_LIBS="-L$(STAGING_DIR)/usr/lib -lliveMedia"
else
VLC_CONF_OPT += --disable-live555
endif

ifeq ($(BR2_PACKAGE_LUA),y)
VLC_CONF_OPT += --enable-lua
VLC_DEPENDENCIES += lua host-lua
else
VLC_CONF_OPT += --disable-lua
endif

ifeq ($(BR2_PACKAGE_QT_GUI_MODULE),y)
VLC_CONF_OPT += --enable-qt
VLC_DEPENDENCIES += qt
else
VLC_CONF_OPT += --disable-qt
endif

ifeq ($(BR2_PACKAGE_SDL_X11),y)
VLC_CONF_OPT += --enable-sdl
VLC_DEPENDENCIES += sdl
else
VLC_CONF_OPT += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_SDL_IMAGE),y)
VLC_CONF_OPT += --enable-sdl-image
VLC_DEPENDENCIES += sdl_image
else
VLC_CONF_OPT += --disable-sdl-image
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
VLC_CONF_OPT += --with-speex
VLC_DEPENDENCIES += speex
else
VLC_CONF_OPT += --without-speex
endif

ifeq ($(BR2_PACKAGE_TREMOR),y)
VLC_CONF_OPT += --enable-tremor
VLC_DEPENDENCIES += tremor
else
VLC_CONF_OPT += --disable-tremor
endif

ifeq ($(BR2_PACKAGE_UDEV),y)
VLC_CONF_OPT += --with-udev
VLC_DEPENDENCIES += udev
else
VLC_CONF_OPT += --without-udev
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
VLC_CONF_OPT += --with-x
VLC_DEPENDENCIES += xlib_libX11
else
VLC_CONF_OPT += --without-x
endif

$(eval $(autotools-package))
