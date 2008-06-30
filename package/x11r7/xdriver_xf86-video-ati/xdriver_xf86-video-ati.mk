################################################################################
#
# xdriver_xf86-video-ati -- ATI video driver
#
################################################################################

XDRIVER_XF86_VIDEO_ATI_VERSION = 6.8.191
XDRIVER_XF86_VIDEO_ATI_SOURCE = xf86-video-ati-$(XDRIVER_XF86_VIDEO_ATI_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_ATI_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_ATI_AUTORECONF = YES
XDRIVER_XF86_VIDEO_ATI_DEPENDENCIES = xserver_xorg-server libdrm xproto_fontsproto xproto_glproto xproto_randrproto xproto_videoproto xproto_xextproto xproto_xf86driproto xproto_xf86miscproto xproto_xineramaproto xproto_xproto
XDRIVER_XF86_VIDEO_ATI_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-ati))
