################################################################################
#
# font-util -- No description available
#
################################################################################

XFONT_FONT_UTIL_VERSION = 1.0.1
XFONT_FONT_UTIL_SOURCE = font-util-$(XFONT_FONT_UTIL_VERSION).tar.bz2
XFONT_FONT_UTIL_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_UTIL_DEPENDENCIES = host-pkg-config
XFONT_FONT_UTIL_INSTALL_STAGING = YES
XFONT_FONT_UTIL_INSTALL_TARGET = NO

define XFONT_FONT_UTIL_POST_INSTALL_FIXES
 package/x11r7/xfont_font-util/post-install.sh $(STAGING_DIR)
endef

XFONT_FONT_UTIL_POST_INSTALL_STAGING_HOOKS += XFONT_FONT_UTIL_POST_INSTALL_FIXES

$(eval $(call AUTOTARGETS,package/x11r7,xfont_font-util))
