################################################################################
#
# xdriver_xf86-video-mach64
#
################################################################################

XDRIVER_XF86_VIDEO_MACH64_VERSION = 810572536e153ac9e4615a35e2ab99dc266806da
XDRIVER_XF86_VIDEO_MACH64_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-mach64
XDRIVER_XF86_VIDEO_MACH64_LICENSE = MIT
XDRIVER_XF86_VIDEO_MACH64_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MACH64_AUTORECONF = YES
XDRIVER_XF86_VIDEO_MACH64_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xproto

$(eval $(autotools-package))
