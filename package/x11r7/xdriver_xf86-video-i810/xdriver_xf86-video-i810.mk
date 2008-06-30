################################################################################
#
# xdriver_xf86-video-i810 -- X.Org driver for Intel cards
#
################################################################################

XDRIVER_XF86_VIDEO_I810_VERSION = 1.7.4
XDRIVER_XF86_VIDEO_I810_SOURCE = xf86-video-i810-$(XDRIVER_XF86_VIDEO_I810_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_I810_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_I810_AUTORECONF = YES
XDRIVER_XF86_VIDEO_I810_DEPENDENCIES = xserver_xorg-server libdrm xlib_libX11 xlib_libXvMC xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xf86driproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-i810))
