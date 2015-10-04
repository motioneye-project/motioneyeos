################################################################################
#
# xdriver_xf86-video-imx
#
################################################################################

XDRIVER_XF86_VIDEO_IMX_VERSION = 11.09.01
XDRIVER_XF86_VIDEO_IMX_SOURCE = xserver-xorg-video-imx-$(XDRIVER_XF86_VIDEO_IMX_VERSION).tar.gz
XDRIVER_XF86_VIDEO_IMX_SITE = $(FREESCALE_IMX_SITE)
XDRIVER_XF86_VIDEO_IMX_DEPENDENCIES = linux libz160 xserver_xorg-server \
	xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto \
	xproto_xf86dgaproto xproto_xproto
XDRIVER_XF86_VIDEO_IMX_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -I$(LINUX_DIR)/include"

$(eval $(autotools-package))
