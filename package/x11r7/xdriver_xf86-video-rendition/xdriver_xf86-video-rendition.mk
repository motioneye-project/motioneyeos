################################################################################
#
# xdriver_xf86-video-rendition -- Rendition video driver
#
################################################################################

XDRIVER_XF86_VIDEO_RENDITION_VERSION = 4.1.3
XDRIVER_XF86_VIDEO_RENDITION_SOURCE = xf86-video-rendition-$(XDRIVER_XF86_VIDEO_RENDITION_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_RENDITION_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_RENDITION_AUTORECONF = NO
XDRIVER_XF86_VIDEO_RENDITION_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-rendition))
