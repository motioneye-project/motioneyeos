################################################################################
#
# xdriver_xf86-video-intel -- Intel video driver
#
################################################################################

XDRIVER_XF86_VIDEO_INTEL_VERSION = 2.10.0
XDRIVER_XF86_VIDEO_INTEL_SOURCE = xf86-video-intel-$(XDRIVER_XF86_VIDEO_INTEL_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_INTEL_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_INTEL_AUTORECONF = YES
XDRIVER_XF86_VIDEO_INTEL_CONF_OPT = --enable-dri
XDRIVER_XF86_VIDEO_INTEL_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xproto libdrm xlib_libpciaccess

$(eval $(autotools-package))
