################################################################################
#
# xdriver_xf86-video-siliconmotion
#
################################################################################

XDRIVER_XF86_VIDEO_SILICONMOTION_VERSION = 1.7.8
XDRIVER_XF86_VIDEO_SILICONMOTION_SOURCE = xf86-video-siliconmotion-$(XDRIVER_XF86_VIDEO_SILICONMOTION_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_SILICONMOTION_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_SILICONMOTION_LICENSE = MIT
XDRIVER_XF86_VIDEO_SILICONMOTION_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_SILICONMOTION_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xproto

XDRIVER_XF86_VIDEO_SILICONMOTION_CONF_OPTS = --disable-selective-werror

$(eval $(autotools-package))
