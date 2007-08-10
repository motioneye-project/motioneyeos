################################################################################
#
# xdriver_xf86-video-newport -- Newport video driver
#
################################################################################

XDRIVER_XF86_VIDEO_NEWPORT_VERSION = 0.2.1
XDRIVER_XF86_VIDEO_NEWPORT_SOURCE = xf86-video-newport-$(XDRIVER_XF86_VIDEO_NEWPORT_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_NEWPORT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_NEWPORT_AUTORECONF = YES
XDRIVER_XF86_VIDEO_NEWPORT_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-newport))
