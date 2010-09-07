################################################################################
#
# xdriver_xf86-video-v4l -- video4linux driver
#
################################################################################

XDRIVER_XF86_VIDEO_V4L_VERSION = 0.2.0
XDRIVER_XF86_VIDEO_V4L_SOURCE = xf86-video-v4l-$(XDRIVER_XF86_VIDEO_V4L_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_V4L_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_V4L_AUTORECONF = NO
XDRIVER_XF86_VIDEO_V4L_DEPENDENCIES = xserver_xorg-server xproto_randrproto xproto_videoproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-v4l))
