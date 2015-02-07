################################################################################
#
# xdriver_xf86-video-neomagic
#
################################################################################

XDRIVER_XF86_VIDEO_NEOMAGIC_VERSION = 6661bdd4551e4e63e983685464a277845aed3012
XDRIVER_XF86_VIDEO_NEOMAGIC_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-neomagic
XDRIVER_XF86_VIDEO_NEOMAGIC_LICENSE = MIT
XDRIVER_XF86_VIDEO_NEOMAGIC_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_NEOMAGIC_AUTORECONF = YES
XDRIVER_XF86_VIDEO_NEOMAGIC_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xextproto xproto_xf86dgaproto xproto_xproto

$(eval $(autotools-package))
