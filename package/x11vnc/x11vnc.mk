#############################################################
#
# X11VNC
#
#############################################################
X11VNC_VERSION = 0.9.3
X11VNC_SOURCE = x11vnc-$(X11VNC_VERSION).tar.gz
X11VNC_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libvncserver
X11VNC_INSTALL_STAGING = NO
X11VNC_INSTALL_TARGET = YES

X11VNC_CONF_OPT = \
	--without-avahi

X11VNC_DEPENDENCIES = xserver_xorg-server xlib_libXt

$(eval $(call AUTOTARGETS,package,x11vnc))
