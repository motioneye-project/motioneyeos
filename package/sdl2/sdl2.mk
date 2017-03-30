################################################################################
#
# sdl2
#
################################################################################

SDL2_VERSION = 2.0.5
SDL2_SOURCE = SDL2-$(SDL2_VERSION).tar.gz
SDL2_SITE = http://www.libsdl.org/release
SDL2_LICENSE = Zlib
SDL2_LICENSE_FILES = COPYING.txt
SDL2_INSTALL_STAGING = YES
SDL2_CONFIG_SCRIPTS = sdl2-config

SDL2_CONF_OPTS += \
	--disable-rpath \
	--disable-arts \
	--disable-esd \
	--disable-dbus \
	--disable-pulseaudio \
	--disable-video-wayland

# We must enable static build to get compilation successful.
SDL2_CONF_OPTS += --enable-static

# From https://bugs.debian.org/cgi-bin/bugreport.cgi/?bug=770670
# "The problem lies within SDL_cpuinfo.h.  It includes altivec.h, which by
# definition provides an unconditional vector, pixel and bool define in
# standard-c++ mode.  In GNU-c++ mode this names are only defined
# context-sensitive by cpp.  SDL_cpuinfo.h is included by SDL.h.
# Including altivec.h makes arbitrary code break."
ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
SDL2_CONF_OPTS += --disable-altivec
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
SDL2_DEPENDENCIES += udev
SDL2_CONF_OPTS += --enable-libudev
else
SDL2_CONF_OPTS += --disable-libudev
endif

ifeq ($(BR2_PACKAGE_SDL2_DIRECTFB),y)
SDL2_DEPENDENCIES += directfb
SDL2_CONF_OPTS += --enable-video-directfb
SDL2_CONF_ENV = ac_cv_path_DIRECTFBCONFIG=$(STAGING_DIR)/usr/bin/directfb-config
else
SDL2_CONF_OPTS += --disable-video-directfb
endif

# x-includes and x-libraries must be set for cross-compiling
# By default x_includes and x_libraries contains unsafe paths.
# (/usr/X11R6/include and /usr/X11R6/lib)
ifeq ($(BR2_PACKAGE_SDL2_X11),y)
SDL2_DEPENDENCIES += xlib_libX11 xlib_libXext

# X11/extensions/shape.h is provided by libXext.
SDL2_CONF_OPTS += --enable-video-x11 \
	--with-x=$(STAGING_DIR) \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib  \
	--enable-video-x11-xshape

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
SDL2_DEPENDENCIES += xlib_libXcursor
SDL2_CONF_OPTS += --enable-video-x11-xcursor
else
SDL2_CONF_OPTS += --disable-video-x11-xcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
SDL2_DEPENDENCIES += xlib_libXinerama
SDL2_CONF_OPTS += --enable-video-x11-xinerama
else
SDL2_CONF_OPTS += --disable-video-x11-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
SDL2_DEPENDENCIES += xlib_libXi
SDL2_CONF_OPTS += --enable-video-x11-xinput
else
SDL2_CONF_OPTS += --disable-video-x11-xinput
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
SDL2_DEPENDENCIES += xlib_libXrandr
SDL2_CONF_OPTS += --enable-video-x11-xrandr
else
SDL2_CONF_OPTS += --disable-video-x11-xrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXSCRNSAVER),y)
SDL2_DEPENDENCIES += xlib_libXScrnSaver
SDL2_CONF_OPTS += --enable-video-x11-scrnsaver
else
SDL2_CONF_OPTS += --disable-video-x11-scrnsaver
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
SDL2_DEPENDENCIES += xlib_libXxf86vm
SDL2_CONF_OPTS += --enable-video-x11-vm
else
SDL2_CONF_OPTS += --disable-video-x11-vm
endif

else
SDL2_CONF_OPTS += --disable-video-x11 --without-x
endif

ifeq ($(BR2_PACKAGE_SDL2_OPENGL),y)
SDL2_CONF_OPTS += --enable-video-opengl
SDL2_DEPENDENCIES += libgl
else
SDL2_CONF_OPTS += --disable-video-opengl
endif

ifeq ($(BR2_PACKAGE_SDL2_OPENGLES),y)
SDL2_CONF_OPTS += --enable-video-opengles
SDL2_DEPENDENCIES += libgles
else
SDL2_CONF_OPTS += --disable-video-opengles
endif

ifeq ($(BR2_PACKAGE_TSLIB),y)
SDL2_DEPENDENCIES += tslib
SDL2_CONF_OPTS += --enable-input-tslib
else
SDL2_CONF_OPTS += --disable-input-tslib
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
SDL2_DEPENDENCIES += alsa-lib
SDL2_CONF_OPTS += --enable-alsa
else
SDL2_CONF_OPTS += --disable-alsa
endif

$(eval $(autotools-package))
