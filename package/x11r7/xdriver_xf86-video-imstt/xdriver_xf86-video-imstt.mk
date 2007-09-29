################################################################################
#
# xdriver_xf86-video-imstt -- Integrated Micro Solutions Twin Turbo 128 driver
#
################################################################################

XDRIVER_XF86_VIDEO_IMSTT_VERSION = 1.1.0
XDRIVER_XF86_VIDEO_IMSTT_SOURCE = xf86-video-imstt-$(XDRIVER_XF86_VIDEO_IMSTT_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_IMSTT_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_IMSTT_AUTORECONF = YES
XDRIVER_XF86_VIDEO_IMSTT_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-imstt))
