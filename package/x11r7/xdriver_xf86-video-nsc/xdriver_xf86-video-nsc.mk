################################################################################
#
# xdriver_xf86-video-nsc -- Nsc video driver
#
################################################################################

XDRIVER_XF86_VIDEO_NSC_VERSION = 2.8.3
XDRIVER_XF86_VIDEO_NSC_SOURCE = xf86-video-nsc-$(XDRIVER_XF86_VIDEO_NSC_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_NSC_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_NSC_AUTORECONF = NO
XDRIVER_XF86_VIDEO_NSC_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xproto

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-nsc))
