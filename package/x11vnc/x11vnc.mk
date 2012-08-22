#############################################################
#
# X11VNC
#
#############################################################
X11VNC_VERSION = 0.9.3
X11VNC_SOURCE = x11vnc-$(X11VNC_VERSION).tar.gz
X11VNC_SITE = http://downloads.sourceforge.net/project/libvncserver/x11vnc/$(X11VNC_VERSION)
X11VNC_CONF_OPT = \
	--without-avahi

X11VNC_DEPENDENCIES = xserver_xorg-server xlib_libXt

$(eval $(autotools-package))
