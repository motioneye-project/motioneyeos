################################################################################
#
# xdriver_xf86-video-vga -- Generic VGA video driver
#
################################################################################

XDRIVER_XF86_VIDEO_VGA_VERSION = 4.1.0
XDRIVER_XF86_VIDEO_VGA_SOURCE = xf86-video-vga-$(XDRIVER_XF86_VIDEO_VGA_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VGA_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VGA_AUTORECONF = NO
XDRIVER_XF86_VIDEO_VGA_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto
XDRIVER_XF86_VIDEO_VGA_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-vga))
