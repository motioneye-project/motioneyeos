################################################################################
#
# xdriver_xf86-video-sunleo -- Leo video driver
#
################################################################################

XDRIVER_XF86_VIDEO_SUNLEO_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_SUNLEO_SOURCE = xf86-video-sunleo-$(XDRIVER_XF86_VIDEO_SUNLEO_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SUNLEO_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SUNLEO_AUTORECONF = YES
XDRIVER_XF86_VIDEO_SUNLEO_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-sunleo))
