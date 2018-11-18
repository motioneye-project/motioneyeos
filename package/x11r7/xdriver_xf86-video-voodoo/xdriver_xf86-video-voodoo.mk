################################################################################
#
# xdriver_xf86-video-voodoo
#
################################################################################

XDRIVER_XF86_VIDEO_VOODOO_VERSION = 9172ae566a0e85313fc80ab62b4455393eefe593
XDRIVER_XF86_VIDEO_VOODOO_SITE = git://anongit.freedesktop.org/xorg/driver/xf86-video-voodoo
XDRIVER_XF86_VIDEO_VOODOO_LICENSE = MIT
XDRIVER_XF86_VIDEO_VOODOO_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_VOODOO_AUTORECONF = YES
XDRIVER_XF86_VIDEO_VOODOO_DEPENDENCIES = xserver_xorg-server xorgproto

$(eval $(autotools-package))
