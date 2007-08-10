################################################################################
#
# xdriver_xf86-video-ast -- No description available
#
################################################################################

XDRIVER_XF86_VIDEO_AST_VERSION = 0.81.0
XDRIVER_XF86_VIDEO_AST_SOURCE = xf86-video-ast-$(XDRIVER_XF86_VIDEO_AST_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_AST_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_AST_AUTORECONF = YES

$(eval $(call AUTOTARGETS,xdriver_xf86-video-ast))
