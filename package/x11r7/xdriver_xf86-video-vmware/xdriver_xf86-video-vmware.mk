################################################################################
#
# xdriver_xf86-video-vmware
#
################################################################################

XDRIVER_XF86_VIDEO_VMWARE_VERSION = 12.0.2
XDRIVER_XF86_VIDEO_VMWARE_SOURCE = xf86-video-vmware-$(XDRIVER_XF86_VIDEO_VMWARE_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VMWARE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VMWARE_LICENSE = MIT
XDRIVER_XF86_VIDEO_VMWARE_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_VMWARE_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xineramaproto xproto_xproto

$(eval $(autotools-package))
