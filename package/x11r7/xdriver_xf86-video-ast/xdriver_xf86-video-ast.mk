################################################################################
#
# xdriver_xf86-video-ast -- No description available
#
################################################################################

XDRIVER_XF86_VIDEO_AST_VERSION = 0.81.0
XDRIVER_XF86_VIDEO_AST_SOURCE = xf86-video-ast-$(XDRIVER_XF86_VIDEO_AST_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_AST_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_AST_AUTORECONF = NO
XDRIVER_XF86_VIDEO_AST_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-video-ast))
