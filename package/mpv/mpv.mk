################################################################################
#
# mpv
#
################################################################################

MPV_VERSION = 0.29.1
MPV_SITE = https://github.com/mpv-player/mpv/archive
MPV_SOURCE = v$(MPV_VERSION).tar.gz
MPV_DEPENDENCIES = \
	host-pkgconf ffmpeg zlib \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
MPV_LICENSE = GPL-2.0+
MPV_LICENSE_FILES = LICENSE.GPL

MPV_NEEDS_EXTERNAL_WAF = YES

# Some of these options need testing and/or tweaks
MPV_CONF_OPTS = \
	--prefix=/usr \
	--disable-android \
	--disable-caca \
	--disable-cocoa \
	--disable-coreaudio \
	--disable-cuda-hwaccel \
	--disable-opensles \
	--disable-rsound \
	--disable-rubberband \
	--disable-uchardet \
	--disable-vapoursynth \
	--disable-vapoursynth-lazy \
	--disable-mali-fbdev

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

# libcdio-paranoia
ifeq ($(BR2_PACKAGE_LIBCDIO_PARANOIA),y)
MPV_CONF_OPTS += --enable-cdda
MPV_DEPENDENCIES += libcdio-paranoia
else
MPV_CONF_OPTS += --disable-cdda
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

# libv4l
ifeq ($(BR2_PACKAGE_LIBV4L),y)
MPV_CONF_OPTS += \
	--enable-libv4l2 \
	--enable-tv
MPV_DEPENDENCIES += libv4l
else
MPV_CONF_OPTS += --disable-libv4l2
endif

# libvdpau
ifeq ($(BR2_PACKAGE_LIBVDPAU),y)
MPV_CONF_OPTS += --enable-vdpau
MPV_DEPENDENCIES += libvdpau
else
MPV_CONF_OPTS += --disable-vdpau
endif

# LUA support, only for lua51/lua52/luajit
# This enables the controller (OSD) together with libass
ifeq ($(BR2_PACKAGE_LUA_5_1)$(BR2_PACKAGE_LUAJIT),y)
MPV_CONF_OPTS += --enable-lua
MPV_DEPENDENCIES += luainterpreter
else
MPV_CONF_OPTS += --disable-lua
endif

# OpenGL support
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
MPV_CONF_OPTS += --enable-gl
MPV_DEPENDENCIES += libgl
else
MPV_CONF_OPTS += --disable-gl
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
# Sdl2 requires 64-bit sync intrinsics
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_8)$(BR2_PACKAGE_SDL2),yy)
MPV_CONF_OPTS += --enable-sdl2
MPV_DEPENDENCIES += sdl2
else
MPV_CONF_OPTS += --disable-sdl2
endif

# Raspberry Pi support
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MPV_CONF_OPTS += --enable-rpi --enable-gl
MPV_DEPENDENCIES += rpi-userland
else
MPV_CONF_OPTS += --disable-rpi
endif

# va-api support
# This requires one or more of the egl-drm, wayland, x11 backends
# For now we support wayland and x11
ifeq ($(BR2_PACKAGE_LIBVA),y)
ifneq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_XORG7),)
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
MPV_DEPENDENCIES += libxkbcommon wayland wayland-protocols
else
MPV_CONF_OPTS += --disable-wayland
endif

# Base X11 support. Config.in ensures that if BR2_PACKAGE_XORG7 is
# enabled, xlib_libX11, xlib_libXext, xlib_libXinerama,
# xlib_libXrandr, xlib_libXScrnSaver.
ifeq ($(BR2_PACKAGE_XORG7),y)
MPV_CONF_OPTS += --enable-x11
MPV_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXinerama xlib_libXrandr xlib_libXScrnSaver
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
