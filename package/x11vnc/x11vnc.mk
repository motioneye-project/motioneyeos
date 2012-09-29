#############################################################
#
# X11VNC
#
#############################################################
X11VNC_VERSION = 0.9.13
X11VNC_SOURCE = x11vnc-$(X11VNC_VERSION).tar.gz
X11VNC_SITE = http://downloads.sourceforge.net/project/libvncserver/x11vnc/$(X11VNC_VERSION)
X11VNC_CONF_OPT = \
	--without-avahi

X11VNC_DEPENDENCIES = xlib_libXt xlib_libXext xlib_libXtst

ifneq ($(BR2_INET_IPV6),y)
# configure option only used for libvncserver
X11VNC_CONF_OPT += --without-ipv6
X11VNC_CONF_ENV += CFLAGS='$(TARGET_CFLAGS) -DX11VNC_IPV6=0'
endif

$(eval $(autotools-package))
