################################################################################
#
# mediastreamer
#
################################################################################

MEDIASTREAMER_VERSION = 2.14.0
MEDIASTREAMER_SITE = http://download.savannah.nongnu.org/releases/linphone/mediastreamer
MEDIASTREAMER_INSTALL_STAGING = YES
MEDIASTREAMER_DEPENDENCIES = host-intltool host-pkgconf ortp host-gettext
# tests fail linking on some architectures, so disable them
MEDIASTREAMER_CONF_OPTS = --disable-tests --disable-glx --disable-strict
MEDIASTREAMER_LICENSE = GPL-2.0+
MEDIASTREAMER_LICENSE_FILES = COPYING

# patching configure.ac
MEDIASTREAMER_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yy)
MEDIASTREAMER_CONF_OPTS += --enable-alsa
MEDIASTREAMER_DEPENDENCIES += alsa-lib
else
MEDIASTREAMER_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_LIBUPNP),y)
MEDIASTREAMER_CONF_OPTS += --enable-upnp
MEDIASTREAMER_DEPENDENCIES += libupnp
else
MEDIASTREAMER_CONF_OPTS += --disable-upnp
endif

ifeq ($(BR2_PACKAGE_LIBVPX),y)
MEDIASTREAMER_CONF_OPTS += --enable-vp8
MEDIASTREAMER_DEPENDENCIES += libvpx
else
MEDIASTREAMER_CONF_OPTS += --disable-vp8
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
MEDIASTREAMER_CONF_OPTS += --enable-opus
MEDIASTREAMER_DEPENDENCIES += opus
else
MEDIASTREAMER_CONF_OPTS += --disable-opus
endif

# portaudio backend needs speex as well
ifeq ($(BR2_PACKAGE_PORTAUDIO)$(BR2_PACKAGE_SPEEX),yy)
MEDIASTREAMER_CONF_OPTS += --enable-portaudio
MEDIASTREAMER_DEPENDENCIES += portaudio speex
else
MEDIASTREAMER_CONF_OPTS += --disable-portaudio
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
MEDIASTREAMER_CONF_OPTS += --enable-pulseaudio
MEDIASTREAMER_DEPENDENCIES += pulseaudio
else
MEDIASTREAMER_CONF_OPTS += --disable-pulseaudio
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
MEDIASTREAMER_CONF_OPTS += --enable-speex
MEDIASTREAMER_DEPENDENCIES += speex
else
MEDIASTREAMER_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
MEDIASTREAMER_CONF_OPTS += --enable-ffmpeg
MEDIASTREAMER_DEPENDENCIES += ffmpeg
else
MEDIASTREAMER_CONF_OPTS += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_SDL),y)
MEDIASTREAMER_CONF_OPTS += --enable-sdl
MEDIASTREAMER_DEPENDENCIES += sdl
else
MEDIASTREAMER_CONF_OPTS += --disable-sdl
endif

# mediastreamer assumes SDL has X11 support if --enable-x11 (and X11 support
# is only used for SDL output)
ifeq ($(BR2_PACKAGE_SDL_X11),y)
MEDIASTREAMER_CONF_OPTS += --enable-x11
else
MEDIASTREAMER_CONF_OPTS += --disable-x11
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXV),y)
MEDIASTREAMER_CONF_OPTS += --enable-xv
MEDIASTREAMER_DEPENDENCIES += xlib_libXv
else
MEDIASTREAMER_CONF_OPTS += --disable-xv
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
MEDIASTREAMER_CONF_OPTS += --enable-theora
MEDIASTREAMER_DEPENDENCIES += libtheora
else
MEDIASTREAMER_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
MEDIASTREAMER_CONF_OPTS += --enable-libv4l1 --enable-libv4l2
MEDIASTREAMER_DEPENDENCIES += libv4l
else
MEDIASTREAMER_CONF_OPTS += --disable-libv4l1 --disable-libv4l2
endif

$(eval $(autotools-package))
