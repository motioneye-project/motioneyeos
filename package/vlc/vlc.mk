################################################################################
#
# vlc
#
################################################################################

VLC_VERSION = 3.0.4
VLC_SITE = https://get.videolan.org/vlc/$(VLC_VERSION)
VLC_SOURCE = vlc-$(VLC_VERSION).tar.xz
VLC_LICENSE = GPL-2.0+, LGPL-2.1+
VLC_LICENSE_FILES = COPYING COPYING.LIB
VLC_DEPENDENCIES = host-pkgconf
VLC_AUTORECONF = YES

# Install vlc libraries in staging.
VLC_INSTALL_STAGING = YES

# gcc bug internal compiler error: in merge_overlapping_regs, at
# regrename.c:304. This bug is fixed since gcc 6.
ifeq ($(BR2_microblaze)$(BR2_or1k):$(BR2_TOOLCHAIN_GCC_AT_LEAST_6),y:)
VLC_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -O0"
VLC_CONF_OPTS += --disable-optimizations
endif

# configure check for -fstack-protector-strong is broken
VLC_CONF_ENV += \
	ax_cv_check_cflags___fstack_protector_strong=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)

# VLC defines two autoconf functions which are also defined by our own pkg.m4
# from pkgconf. Unfortunately, they are defined in a different way: VLC adds
# --enable- options, but pkg.m4 adds --with- options. To make sure we use
# VLC's definition, rename these two functions.
define VLC_OVERRIDE_PKG_M4
	$(SED) 's/PKG_WITH_MODULES/VLC_PKG_WITH_MODULES/g' \
		-e 's/PKG_HAVE_WITH_MODULES/VLC_PKG_HAVE_WITH_MODULES/g' \
		$(@D)/configure.ac $(@D)/m4/with_pkg.m4
endef
VLC_POST_PATCH_HOOKS += VLC_OVERRIDE_PKG_M4

VLC_CONF_OPTS += \
	--disable-a52 \
	--disable-addonmanagermodules \
	--disable-aom \
	--disable-aribb25 \
	--disable-aribsub \
	--disable-asdcp \
	--disable-bpg \
	--disable-caca \
	--disable-chromaprint \
	--disable-chromecast \
	--disable-crystalhd \
	--disable-dc1394 \
	--disable-dca \
	--disable-decklink \
	--disable-dsm \
	--disable-dv1394 \
	--disable-fluidlite \
	--disable-fluidsynth \
	--disable-gme \
	--disable-goom \
	--disable-jack \
	--disable-jpeg \
	--disable-kai \
	--disable-kate \
	--disable-kva \
	--disable-libplacebo \
	--disable-linsys \
	--disable-mfx \
	--disable-microdns \
	--disable-mmal \
	--disable-mtp \
	--disable-notify \
	--disable-projectm \
	--disable-schroedinger \
	--disable-shine \
	--disable-shout \
	--disable-sndio \
	--disable-spatialaudio \
	--disable-srt \
	--disable-telx \
	--disable-tiger \
	--disable-twolame \
	--disable-vdpau \
	--disable-vsxu \
	--disable-wasapi \
	--disable-x262 \
	--disable-zvbi \
	--enable-run-as-root

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
VLC_CONF_ENV += LIBS="-latomic"
endif

# Building static and shared doesn't work, so force static off.
ifeq ($(BR2_STATIC_LIBS),)
VLC_CONF_OPTS += --disable-static
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
VLC_CONF_OPTS += --enable-altivec
else
VLC_CONF_OPTS += --disable-altivec
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
VLC_CONF_OPTS += --enable-sse
else
VLC_CONF_OPTS += --disable-sse
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
VLC_CONF_OPTS += --enable-alsa
VLC_DEPENDENCIES += alsa-lib
else
VLC_CONF_OPTS += --disable-alsa
endif

# avahi support needs avahi-client, which needs avahi-daemon and dbus
ifeq ($(BR2_PACKAGE_AVAHI)$(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_DBUS),yyy)
VLC_CONF_OPTS += --enable-avahi
VLC_DEPENDENCIES += avahi
else
VLC_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
VLC_CONF_OPTS += --enable-dbus
VLC_DEPENDENCIES += dbus
else
VLC_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_FAAD2),y)
VLC_CONF_OPTS += --enable-faad
VLC_DEPENDENCIES += faad2
else
VLC_CONF_OPTS += --disable-faad
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
VLC_CONF_OPTS += --enable-avcodec
VLC_DEPENDENCIES += ffmpeg
else
VLC_CONF_OPTS += --disable-avcodec
endif

ifeq ($(BR2_PACKAGE_FFMPEG_POSTPROC),y)
VLC_CONF_OPTS += --enable-postproc
else
VLC_CONF_OPTS += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
VLC_CONF_OPTS += --enable-swscale
else
VLC_CONF_OPTS += --disable-swscale
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
VLC_CONF_OPTS += --enable-flac
VLC_DEPENDENCIES += flac
else
VLC_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_FREERDP),y)
VLC_CONF_OPTS += --enable-freerdp
VLC_DEPENDENCIES += freerdp
else
VLC_CONF_OPTS += --disable-freerdp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
VLC_CONF_OPTS += --enable-gst-decode
VLC_DEPENDENCIES += gst1-plugins-base
else
VLC_CONF_OPTS += --disable-gst-decode
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
VLC_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_HARFBUZZ),y)
VLC_CONF_OPTS += --enable-harfbuzz
VLC_DEPENDENCIES += harfbuzz
else
VLC_CONF_OPTS += --disable-harfbuzz
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
VLC_CONF_OPTS += --enable-gles2
VLC_DEPENDENCIES += libgles
else
VLC_CONF_OPTS += --disable-gles2
endif

ifeq ($(BR2_PACKAGE_OPENCV)$(BR2_PACKAGE_OPENCV3),y)
VLC_CONF_OPTS += --enable-opencv
ifeq ($(BR2_PACKAGE_OPENCV),y)
VLC_DEPENDENCIES += opencv
else
VLC_DEPENDENCIES += opencv3
endif
else
VLC_CONF_OPTS += --disable-opencv
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
VLC_CONF_OPTS += --enable-opus
VLC_DEPENDENCIES += libvorbis opus
else
VLC_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
VLC_CONF_OPTS += --enable-archive
VLC_DEPENDENCIES += libarchive
else
VLC_CONF_OPTS += --disable-archive
endif

ifeq ($(BR2_PACKAGE_LIBASS),y)
VLC_CONF_OPTS += --enable-libass
VLC_DEPENDENCIES += libass
else
VLC_CONF_OPTS += --disable-libass
endif

ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
VLC_CONF_OPTS += --enable-bluray
VLC_DEPENDENCIES += libbluray
else
VLC_CONF_OPTS += --disable-bluray
endif

ifeq ($(BR2_PACKAGE_LIBCDDB),y)
VLC_CONF_OPTS += --enable-libcddb
VLC_DEPENDENCIES += libcddb
else
VLC_CONF_OPTS += --disable-libcddb
endif

ifeq ($(BR2_PACKAGE_LIBDVBPSI),y)
VLC_CONF_OPTS += --enable-dvbpsi
VLC_DEPENDENCIES += libdvbpsi
else
VLC_CONF_OPTS += --disable-dvbpsi
endif

ifeq ($(BR2_PACKAGE_LIBDVDNAV),y)
VLC_CONF_OPTS += --enable-dvdnav
VLC_DEPENDENCIES += libdvdnav
else
VLC_CONF_OPTS += --disable-dvdnav
endif

ifeq ($(BR2_PACKAGE_LIBDVDREAD),y)
VLC_CONF_OPTS += --enable-dvdread
VLC_DEPENDENCIES += libdvdread
else
VLC_CONF_OPTS += --disable-dvdread
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
VLC_CONF_OPTS += --enable-libgcrypt
VLC_DEPENDENCIES += libgcrypt
VLC_CONF_ENV += \
	GCRYPT_CONFIG="$(STAGING_DIR)/usr/bin/libgcrypt-config"
else
VLC_CONF_OPTS += --disable-libgcrypt
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
VLC_DEPENDENCIES += libidn
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
VLC_CONF_OPTS += --enable-mad
VLC_DEPENDENCIES += libmad
else
VLC_CONF_OPTS += --disable-mad
endif

ifeq ($(BR2_PACKAGE_LIBMATROSKA),y)
VLC_CONF_OPTS += --enable-matroska
VLC_DEPENDENCIES += libmatroska
else
VLC_CONF_OPTS += --disable-matroska
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
VLC_CONF_OPTS += --enable-mod
VLC_DEPENDENCIES += libmodplug
else
VLC_CONF_OPTS += --disable-mod
endif

ifeq ($(BR2_PACKAGE_LIBMPEG2),y)
VLC_CONF_OPTS += --enable-libmpeg2
VLC_DEPENDENCIES += libmpeg2
else
VLC_CONF_OPTS += --disable-libmpeg2
endif

ifeq ($(BR2_PACKAGE_LIBNFS),y)
VLC_CONF_OPTS += --enable-nfs
VLC_DEPENDENCIES += libnfs
else
VLC_CONF_OPTS += --disable-nfs
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
VLC_CONF_OPTS += --enable-png
VLC_DEPENDENCIES += libpng
else
VLC_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_LIBRSVG),y)
VLC_CONF_OPTS += --enable-svg --enable-svgdec
VLC_DEPENDENCIES += librsvg
else
VLC_CONF_OPTS += --disable-svg --disable-svgdec
endif

ifeq ($(BR2_PACKAGE_LIBSAMPLERATE),y)
VLC_CONF_OPTS += --enable-samplerate
VLC_DEPENDENCIES += libsamplerate
else
VLC_CONF_OPTS += --disable-samplerate
endif

ifeq ($(BR2_PACKAGE_LIBSECRET),y)
VLC_CONF_OPTS += --enable-secret
VLC_DEPENDENCIES += libsecret
else
VLC_CONF_OPTS += --disable-secret
endif

ifeq ($(BR2_PACKAGE_LIBSOXR),y)
VLC_CONF_OPTS += --enable-soxr
VLC_DEPENDENCIES += libsoxr
else
VLC_CONF_OPTS += --disable-soxr
endif

ifeq ($(BR2_PACKAGE_LIBSSH2),y)
VLC_CONF_OPTS += --enable-sftp
VLC_DEPENDENCIES += libssh2
else
VLC_CONF_OPTS += --disable-sftp
endif

ifeq ($(BR2_PACKAGE_LIBSIDPLAY2),y)
VLC_CONF_OPTS += --enable-sid
VLC_DEPENDENCIES += libsidplay2
else
VLC_CONF_OPTS += --disable-sid
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
VLC_CONF_OPTS += --enable-theora
VLC_DEPENDENCIES += libtheora
else
VLC_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_LIBUPNP)$(BR2_PACKAGE_LIBUPNP18),y)
VLC_CONF_OPTS += --enable-upnp
VLC_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBUPNP),libupnp,libupnp18)
else
VLC_CONF_OPTS += --disable-upnp
endif

# libva support depends on ffmpeg
ifeq ($(BR2_PACKAGE_FFMPEG)$(BR2_PACKAGE_LIBVA),yy)
VLC_CONF_OPTS += --enable-libva
VLC_DEPENDENCIES += libva
else
VLC_CONF_OPTS += --disable-libva
endif

ifeq ($(BR2_PACKAGE_LIBVNCSERVER),y)
VLC_CONF_OPTS += --enable-vnc
VLC_DEPENDENCIES += libvncserver
else
VLC_CONF_OPTS += --disable-vnc
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
VLC_CONF_OPTS += --enable-vorbis
VLC_DEPENDENCIES += libvorbis
else
VLC_CONF_OPTS += --disable-vorbis
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
VLC_CONF_OPTS += --enable-v4l2
VLC_DEPENDENCIES += libv4l
else
VLC_CONF_OPTS += --disable-v4l2
endif

ifeq ($(BR2_PACKAGE_LIBVPX),y)
VLC_CONF_OPTS += --enable-vpx
VLC_DEPENDENCIES += libvpx
else
VLC_CONF_OPTS += --disable-vpx
endif

ifeq ($(BR2_PACKAGE_LIBXCB),y)
VLC_CONF_OPTS += --enable-xcb
VLC_DEPENDENCIES += libxcb
else
VLC_CONF_OPTS += --disable-xcb
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
VLC_CONF_OPTS += --enable-libxml2
VLC_DEPENDENCIES += libxml2
else
VLC_CONF_OPTS += --disable-libxml2
endif

ifeq ($(BR2_PACKAGE_LIVE555),y)
VLC_CONF_OPTS += --enable-live555
VLC_DEPENDENCIES += live555
else
VLC_CONF_OPTS += --disable-live555
endif

ifeq ($(BR2_PACKAGE_LUA),y)
VLC_CONF_OPTS += --enable-lua
VLC_DEPENDENCIES += lua host-lua
else
VLC_CONF_OPTS += --disable-lua
endif

ifeq ($(BR2_PACKAGE_MINIZIP),y)
VLC_DEPENDENCIES += minizip
endif

ifeq ($(BR2_PACKAGE_MPG123),y)
VLC_CONF_OPTS += --enable-mpg123
VLC_DEPENDENCIES += mpg123
else
VLC_CONF_OPTS += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_MUSEPACK),y)
VLC_CONF_OPTS += --enable-mpc
VLC_DEPENDENCIES += musepack
else
VLC_CONF_OPTS += --disable-mpc
endif

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
VLC_CONF_OPTS += --enable-ncurses
VLC_DEPENDENCIES += ncurses
else
VLC_CONF_OPTS += --disable-ncurses
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
VLC_CONF_OPTS += --enable-pulse
VLC_DEPENDENCIES += pulseaudio
else
VLC_CONF_OPTS += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS)$(BR2_PACKAGE_QT5SVG),yy)
VLC_CONF_OPTS += --enable-qt
VLC_DEPENDENCIES += qt5base qt5svg
ifeq ($(BR2_PACKAGE_XLIB_LIBXEXT)$(BR2_PACKAGE_XLIB_LIBXINERAMA)$(BR2_PACKAGE_XLIB_LIBXPM),yyy)
VLC_CONF_OPTS += --enable-skins2
VLC_DEPENDENCIES += xlib_libXext xlib_libXinerama xlib_libXpm
else
VLC_CONF_OPTS += --disable-skins2
endif
else
VLC_CONF_OPTS += --disable-qt --disable-skins2
endif

ifeq ($(BR2_PACKAGE_SDL_IMAGE),y)
VLC_CONF_OPTS += --enable-sdl-image
VLC_DEPENDENCIES += sdl_image
else
VLC_CONF_OPTS += --disable-sdl-image
endif

ifeq ($(BR2_PACKAGE_SAMBA4),y)
VLC_CONF_OPTS += --enable-smbclient
VLC_DEPENDENCIES += samba4
else
VLC_CONF_OPTS += --disable-smbclient
endif

ifeq ($(BR2_PACKAGE_SPEEX)$(BR2_PACKAGE_SPEEXDSP),yy)
VLC_CONF_OPTS += --enable-speex
VLC_DEPENDENCIES += speex speexdsp
else
VLC_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_TAGLIB),y)
VLC_CONF_OPTS += --enable-taglib
VLC_DEPENDENCIES += taglib
else
VLC_CONF_OPTS += --disable-taglib
endif

ifeq ($(BR2_PACKAGE_TREMOR),y)
VLC_CONF_OPTS += --enable-tremor
VLC_DEPENDENCIES += tremor
else
VLC_CONF_OPTS += --disable-tremor
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
VLC_CONF_OPTS += --enable-udev
VLC_DEPENDENCIES += udev
else
VLC_CONF_OPTS += --disable-udev
endif

ifeq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_WAYLAND_PROTOCOLS),yy)
VLC_CONF_OPTS += --enable-wayland
VLC_DEPENDENCIES += wayland wayland-protocols
else
VLC_CONF_OPTS += --disable-wayland
endif

ifeq ($(BR2_PACKAGE_X264),y)
VLC_CONF_OPTS += --enable-x264
VLC_DEPENDENCIES += x264
else
VLC_CONF_OPTS += --disable-x264
endif

ifeq ($(BR2_PACKAGE_X265),y)
VLC_CONF_OPTS += --enable-x265
VLC_DEPENDENCIES += x265
else
VLC_CONF_OPTS += --disable-x265
endif

ifeq ($(BR2_PACKAGE_XCB_UTIL_KEYSYMS),y)
VLC_DEPENDENCIES += xcb-util-keysyms
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
VLC_CONF_OPTS += --with-x
VLC_DEPENDENCIES += xlib_libX11
else
VLC_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
VLC_DEPENDENCIES += zlib
endif

$(eval $(autotools-package))
