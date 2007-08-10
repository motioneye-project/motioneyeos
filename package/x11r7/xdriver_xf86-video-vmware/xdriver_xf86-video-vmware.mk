################################################################################
#
# xdriver_xf86-video-vmware -- VMware SVGA video driver
#
################################################################################

XDRIVER_XF86_VIDEO_VMWARE_VERSION = 10.14.1
XDRIVER_XF86_VIDEO_VMWARE_SOURCE = xf86-video-vmware-$(XDRIVER_XF86_VIDEO_VMWARE_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_VMWARE_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_VMWARE_AUTORECONF = YES
XDRIVER_XF86_VIDEO_VMWARE_DEPENDANCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_xextproto xproto_xineramaproto xproto_xproto

$(eval $(call AUTOTARGETS,xdriver_xf86-video-vmware))
