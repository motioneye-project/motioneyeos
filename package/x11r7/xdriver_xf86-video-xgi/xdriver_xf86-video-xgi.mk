################################################################################
#
# xdriver_xf86-video-xgi -- XGI video driver
#
################################################################################

XDRIVER_XF86_VIDEO_XGI_VERSION = 1.5.0
XDRIVER_XF86_VIDEO_XGI_SOURCE = xf86-video-xgi-$(XDRIVER_XF86_VIDEO_VESA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_XGI_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_XGI_AUTORECONF = NO
XDRIVER_XF86_VIDEO_XGI_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto
XDRIVER_XF86_VIDEO_XGI_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-xgi))
