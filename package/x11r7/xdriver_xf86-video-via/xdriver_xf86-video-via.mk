################################################################################
#
# xdriver_xf86-video-via -- VIA unichrome graphics driver
#
################################################################################

XDRIVER_XF86_VIDEO_VIA_VERSION = 0.2.2
XDRIVER_XF86_VIDEO_VIA_SOURCE = xf86-video-via-$(XDRIVER_XF86_VIDEO_VIA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VIA_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VIA_AUTORECONF = NO
XDRIVER_XF86_VIDEO_VIA_DEPENDENCIES = xserver_xorg-server libdrm xlib_libX11 xlib_libXvMC xproto_fontsproto xproto_glproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-via))
