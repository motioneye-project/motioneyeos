###############################################################################
#
# mjpegtools
#
###############################################################################

MJPEGTOOLS_VERSION = 2.1.0
MJPEGTOOLS_SITE = http://sourceforge.net/projects/mjpeg/files/mjpegtools/$(MJPEGTOOLS_VERSION)
MJPEGTOOLS_DEPENDENCIES = host-pkgconf jpeg
MJPEGTOOLS_LICENSE = GPLv2+
MJPEGTOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBPNG),y)
MJPEGTOOLS_CONF_OPTS += --with-libpng
MJPEGTOOLS_DEPENDENCIES += libpng
else
MJPEGTOOLS_CONF_OPTS += --without-libpng
endif

# expects X11 backend in sdl
ifeq ($(BR2_PACKAGE_SDL_X11),y)
MJPEGTOOLS_CONF_OPTS += --with-libsdl
MJPEGTOOLS_DEPENDENCIES += sdl
else
MJPEGTOOLS_CONF_OPTS += --without-libsdl
endif

ifeq ($(BR2_PACKAGE_SDL_GFX),y)
MJPEGTOOLS_CONF_OPTS += --with-sdlgfx
MJPEGTOOLS_DEPENDENCIES += sdl_gfx
else
MJPEGTOOLS_CONF_OPTS += --without-sdlgfx
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
MJPEGTOOLS_CONF_OPTS += --with-x
MJPEGTOOLS_DEPENDENCIES += xlib_libX11
else
MJPEGTOOLS_CONF_OPTS += --without-x
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86DGA),y)
MJPEGTOOLS_CONF_OPTS += --with-dga
MJPEGTOOLS_DEPENDENCIES += xlib_libXxf86dga
else
MJPEGTOOLS_CONF_OPTS += --without-dga
endif

ifeq ($(BR2_PACKAGE_LIBGTK2),y)
MJPEGTOOLS_CONF_OPTS += --with-gtk
MJPEGTOOLS_DEPENDENCIES += libgtk2
else
MJPEGTOOLS_CONF_OPTS += --without-gtk
endif

$(eval $(autotools-package))
