MEDIASTREAMER_VERSION = 2.8.2
MEDIASTREAMER_SITE = http://download.savannah.nongnu.org/releases/linphone/mediastreamer
MEDIASTREAMER_INSTALL_STAGING = YES
MEDIASTREAMER_DEPENDENCIES = host-intltool host-pkg-config ortp
# tests fail linking on some architectures, so disable them
MEDIASTREAMER_CONF_OPT = --disable-tests

ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yy)
MEDIASTREAMER_CONF_OPT += --enable-alsa
MEDIASTREAMER_DEPENDENCIES += alsa-lib
else
MEDIASTREAMER_CONF_OPT += --disable-alsa
endif

# portaudio backend needs speex as well
ifeq ($(BR2_PACKAGE_PORTAUDIO)$(BR2_PACKAGE_SPEEX),yy)
MEDIASTREAMER_CONF_OPT += --enable-portaudio
MEDIASTREAMER_DEPENDENCIES += portaudio speex
else
MEDIASTREAMER_CONF_OPT += --disable-portaudio
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
MEDIASTREAMER_CONF_OPT += --enable-pulseaudio
MEDIASTREAMER_DEPENDENCIES += pulseaudio
else
MEDIASTREAMER_CONF_OPT += --disable-pulseaudio
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
MEDIASTREAMER_CONF_OPT += --enable-speex
MEDIASTREAMER_DEPENDENCIES += speex
else
MEDIASTREAMER_CONF_OPT += --disable-speex
endif

ifeq ($(BR2_PACKAGE_FFMPEG_SWSCALE),y)
MEDIASTREAMER_CONF_OPT += --enable-ffmpeg
MEDIASTREAMER_DEPENDENCIES += ffmpeg
else
MEDIASTREAMER_CONF_OPT += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_SDL),y)
MEDIASTREAMER_CONF_OPT += --enable-sdl
MEDIASTREAMER_DEPENDENCIES += sdl
else
MEDIASTREAMER_CONF_OPT += --disable-sdl
endif

# mediastreamer assumes SDL has X11 support if --enable-x11 (and X11 support
# is only used for SDL output)
ifeq ($(BR2_PACKAGE_SDL_X11),y)
MEDIASTREAMER_CONF_OPT += --enable-x11
else
MEDIASTREAMER_CONF_OPT += --disable-x11
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXV),y)
MEDIASTREAMER_CONF_OPT += --enable-xv
MEDIASTREAMER_DEPENDENCIES += xlib_libXv
else
MEDIASTREAMER_CONF_OPT += --disable-xv
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
MEDIASTREAMER_CONF_OPT += --enable-theora
MEDIASTREAMER_DEPENDENCIES += libtheora
else
MEDIASTREAMER_CONF_OPT += --disable-theora
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
MEDIASTREAMER_CONF_OPT += --enable-libv4l1 --enable-libv4l2
MEDIASTREAMER_DEPENDENCIES += libv4l
else
MEDIASTREAMER_CONF_OPT += --disable-libv4l1 --disable-libv4l2
endif

$(eval $(autotools-package))
