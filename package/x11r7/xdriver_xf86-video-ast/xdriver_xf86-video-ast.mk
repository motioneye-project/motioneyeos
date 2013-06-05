################################################################################
#
# xdriver_xf86-video-ast
#
################################################################################

XDRIVER_XF86_VIDEO_AST_VERSION = 0.93.10
XDRIVER_XF86_VIDEO_AST_SOURCE = xf86-video-ast-$(XDRIVER_XF86_VIDEO_AST_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_AST_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_AST_LICENSE = MIT
XDRIVER_XF86_VIDEO_AST_LICENSE_FILES = COPYING

$(eval $(autotools-package))
