################################################################################
#
# xapp_xdm -- X.Org xdm application
#
################################################################################

XAPP_XDM_VERSION = 1.1.6
XAPP_XDM_SOURCE = xdm-$(XAPP_XDM_VERSION).tar.bz2
XAPP_XDM_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_XDM_AUTORECONF = NO
XAPP_XDM_CONF_ENV = ac_cv_file__dev_urandom=yes
XAPP_XDM_DEPENDENCIES = xapp_xinit xapp_sessreg xapp_xrdb xlib_libX11 xlib_libXaw xlib_libXdmcp xlib_libXinerama xlib_libXt xproto_xineramaproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xapp_xdm))
