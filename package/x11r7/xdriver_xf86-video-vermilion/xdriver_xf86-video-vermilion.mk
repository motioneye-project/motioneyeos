################################################################################
#
# xdriver_xf86-video-vermilion -- vermilion video driver
#
################################################################################

XDRIVER_XF86_VIDEO_VERMILION_VERSION = 1.0.1
XDRIVER_XF86_VIDEO_VERMILION_SOURCE = xf86-video-vermilion-$(XDRIVER_XF86_VIDEO_VERMILION_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VERMILION_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VERMILION_AUTORECONF = NO
XDRIVER_XF86_VIDEO_VERMILION_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto
XDRIVER_XF86_VIDEO_VERMILION_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-vermilion))
