################################################################################
#
# mpv
#
################################################################################

MPV_VERSION = 0.23.0
MPV_SITE = https://github.com/mpv-player/mpv/archive
MPV_SOURCE = v$(MPV_VERSION).tar.gz
MPV_DEPENDENCIES = \
	host-pkgconf ffmpeg zlib \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
MPV_LICENSE = GPLv2+
MPV_LICENSE_FILES = LICENSE

MPV_NEEDS_EXTERNAL_WAF = YES

# Some of these options need testing and/or tweaks
MPV_CONF_OPTS = \
	--prefix=/usr \
	--disable-android \
	--disable-caca \
	--disable-cdda \
	--disable-cocoa \
	--disable-coreaudio \
	--disable-libv4l2 \
	--disable-opensles \
	--disable-rpi \
	--disable-rsound \
	--disable-rubberband \
	--disable-uchardet \
	--disable-vapoursynth \
	--disable-vapoursynth-lazy \
	--disable-vdpau

# ALSA support requires pcm+mixer
ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yy)
MPV_CONF_OPTS += --enable-alsa
MPV_DEPENDENCIES += alsa-lib
else
MPV_CONF_OPTS += --disable-alsa
endif

# GBM support is provided by mesa3d when EGL=y
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
MPV_CONF_OPTS += --enable-gbm
MPV_DEPENDENCIES += mesa3d
else
MPV_CONF_OPTS += --disable-gbm
endif

# jack support
# It also requires 64-bit sync intrinsics
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_8)$(BR2_PACKAGE_JACK2),yy)
MPV_CONF_OPTS += --enable-jack
MPV_DEPENDENCIES += jack2
else
MPV_CONF_OPTS += --disable-jack
endif

# jpeg support
ifeq ($(BR2_PACKAGE_JPEG),y)
MPV_CONF_OPTS += --enable-jpeg
MPV_DEPENDENCIES += jpeg
else
MPV_CONF_OPTS += --disable-jpeg
endif

# lcms2 support
ifeq ($(BR2_PACKAGE_LCMS2),y)
MPV_CONF_OPTS += --enable-lcms2
MPV_DEPENDENCIES += lcms2
else
MPV_CONF_OPTS += --disable-lcms2
endif

# libarchive support
ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
MPV_CONF_OPTS += --enable-libarchive
MPV_DEPENDENCIES += libarchive
else
MPV_CONF_OPTS += --disable-libarchive
endif

# libass subtitle support
ifeq ($(BR2_PACKAGE_LIBASS),y)
MPV_CONF_OPTS += --enable-libass
MPV_DEPENDENCIES += libass
else
MPV_CONF_OPTS += --disable-libass
endif

# bluray support
ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
MPV_CONF_OPTS += --enable-libbluray
MPV_DEPENDENCIES += libbluray
else
MPV_CONF_OPTS += --disable-libbluray
endif

# libdvdnav
ifeq ($(BR2_PACKAGE_LIBDVDNAV),y)
MPV_CONF_OPTS += --enable-dvdnav
MPV_DEPENDENCIES += libdvdnav
else
MPV_CONF_OPTS += --disable-dvdnav
endif

# libdvdread
ifeq ($(BR2_PACKAGE_LIBDVDREAD),y)
MPV_CONF_OPTS += --enable-dvdread
MPV_DEPENDENCIES += libdvdread
else
MPV_CONF_OPTS += --disable-dvdread
endif

# libdrm
ifeq ($(BR2_PACKAGE_LIBDRM),y)
MPV_CONF_OPTS += --enable-drm
MPV_DEPENDENCIES += libdrm
else
MPV_CONF_OPTS += --disable-drm
endif

# LUA support, only for lua51/lua52/luajit
# This enables the controller (OSD) together with libass
ifeq ($(BR2_PACKAGE_LUA_5_1)$(BR2_PACKAGE_LUA_5_2)$(BR2_PACKAGE_LUAJIT),y)
MPV_CONF_OPTS += --enable-lua
MPV_DEPENDENCIES += luainterpreter
else
MPV_CONF_OPTS += --disable-lua
endif

# OpenGL support
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
MPV_CONF_OPTS += --enable-gl --enable-standard-gl
MPV_DEPENDENCIES += libgl
else
MPV_CONF_OPTS += --disable-gl --disable-standard-gl
endif

# pulseaudio support
ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
MPV_CONF_OPTS += --enable-pulse
MPV_DEPENDENCIES += pulseaudio
else
MPV_CONF_OPTS += --disable-pulse
endif

# samba support
ifeq ($(BR2_PACKAGE_SAMBA4),y)
MPV_CONF_OPTS += --enable-libsmbclient
MPV_DEPENDENCIES += samba4
else
MPV_CONF_OPTS += --disable-libsmbclient
endif

# SDL support
# Both can't be used at the same time, prefer newer API
# It also requires 64-bit sync intrinsics
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_8)$(BR2_PACKAGE_SDL2),yy)
MPV_CONF_OPTS += --enable-sdl2 --disable-sdl1
MPV_DEPENDENCIES += sdl2
else ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_8)$(BR2_PACKAGE_SDL),yy)
MPV_CONF_OPTS += --enable-sdl1 --disable-sdl2
MPV_DEPENDENCIES += sdl
else
MPV_CONF_OPTS += --disable-sdl1 --disable-sdl2
endif

# va-api support
# This requires one or more of the egl-drm, wayland, x11 backends
# For now we support wayland and x11
ifeq ($(BR2_PACKAGE_LIBVA),y)
ifneq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_XLIB_LIBX11),)
MPV_CONF_OPTS += --enable-vaapi
MPV_DEPENDENCIES += libva
else
MPV_CONF_OPTS += --disable-vaapi
endif
else
MPV_CONF_OPTS += --disable-vaapi
endif

# wayland support
ifeq ($(BR2_PACKAGE_WAYLAND),y)
MPV_CONF_OPTS += --enable-wayland
MPV_DEPENDENCIES += libxkbcommon wayland
else
MPV_CONF_OPTS += --disable-wayland
endif

# Base X11 support
ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
MPV_CONF_OPTS += --enable-x11 --disable-xss
MPV_DEPENDENCIES += xlib_libX11
# xext
ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT),y)
MPV_CONF_OPTS += --enable-xext
MPV_DEPENDENCIES += xlib_libXext
else
MPV_CONF_OPTS += --disable-xext
endif
# xinerama
ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
MPV_CONF_OPTS += --enable-xinerama
MPV_DEPENDENCIES += xlib_libXinerama
else
MPV_CONF_OPTS += --disable-xinerama
endif
# xrandr
ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
MPV_CONF_OPTS += --enable-xrandr
MPV_DEPENDENCIES += xlib_libXrandr
else
MPV_CONF_OPTS += --disable-xrandr
endif
# XVideo
ifeq ($(BR2_PACKAGE_XLIB_LIBXV),y)
MPV_CONF_OPTS += --enable-xv
MPV_DEPENDENCIES += xlib_libXv
else
MPV_CONF_OPTS += --disable-xv
endif
else
MPV_CONF_OPTS += --disable-x11
endif

$(eval $(waf-package))
