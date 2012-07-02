################################################################################
#
# xdriver_xf86-video-ast -- No description available
#
################################################################################

XDRIVER_XF86_VIDEO_AST_VERSION = 0.89.9
XDRIVER_XF86_VIDEO_AST_SOURCE = xf86-video-ast-$(XDRIVER_XF86_VIDEO_AST_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_AST_SITE = http://xorg.freedesktop.org/releases/individual/driver

$(eval $(autotools-package))
