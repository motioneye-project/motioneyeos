################################################################################
#
# x11vnc
#
################################################################################

X11VNC_VERSION = 0.9.13
X11VNC_SITE = http://downloads.sourceforge.net/project/libvncserver/x11vnc/$(X11VNC_VERSION)
# sdl support is not used in x11vnc, but host include / library search paths
# leak in if host has sdl-config
X11VNC_CONF_OPTS = --without-sdl
X11VNC_DEPENDENCIES = xlib_libXt xlib_libXext xlib_libXtst
X11VNC_LICENSE = GPLv2+
X11VNC_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_DBUS),yy)
X11VNC_DEPENDENCIES += avahi dbus
else
X11VNC_CONF_OPTS += --without-avahi
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
X11VNC_DEPENDENCIES += jpeg
else
X11VNC_CONF_OPTS += --without-jpeg
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
X11VNC_DEPENDENCIES += openssl
else
X11VNC_CONF_OPTS += --without-ssl --without-crypto
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
X11VNC_DEPENDENCIES += xlib_libXinerama
else
X11VNC_CONF_OPTS += --without-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
X11VNC_DEPENDENCIES += xlib_libXrandr
else
X11VNC_CONF_OPTS += --without-xrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
X11VNC_DEPENDENCIES += xlib_libXfixes
else
X11VNC_CONF_OPTS += --without-xfixes
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
X11VNC_DEPENDENCIES += xlib_libXdamage
else
X11VNC_CONF_OPTS += --without-xdamage
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
X11VNC_DEPENDENCIES += zlib
else
X11VNC_CONF_OPTS += --without-zlib
endif


$(eval $(autotools-package))
