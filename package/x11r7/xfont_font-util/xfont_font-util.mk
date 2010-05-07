################################################################################
#
# font-util -- No description available
#
################################################################################

XFONT_FONT_UTIL_VERSION = 1.1.1
XFONT_FONT_UTIL_SOURCE = font-util-$(XFONT_FONT_UTIL_VERSION).tar.bz2
XFONT_FONT_UTIL_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_UTIL_DEPENDENCIES = host-pkg-config
XFONT_FONT_UTIL_INSTALL_STAGING = YES
XFONT_FONT_UTIL_INSTALL_TARGET = NO

HOST_XFONT_FONT_UTIL_DEPENDENCIES = host-pkg-config

define XFONT_FONT_UTIL_POST_INSTALL_FIXES
	sed "s,^mapdir=.*,mapdir=$(STAGING_DIR)/usr/share/fonts/X11/util,g" \
		$(STAGING_DIR)/usr/lib/pkgconfig/fontutil.pc > $(STAGING_DIR)/usr/lib/pkgconfig/fontutil.pc.new
	mv $(STAGING_DIR)/usr/lib/pkgconfig/fontutil.pc.new $(STAGING_DIR)/usr/lib/pkgconfig/fontutil.pc
endef

XFONT_FONT_UTIL_POST_INSTALL_STAGING_HOOKS += XFONT_FONT_UTIL_POST_INSTALL_FIXES

$(eval $(call AUTOTARGETS,package/x11r7,xfont_font-util))
$(eval $(call AUTOTARGETS,package/x11r7,xfont_font-util,host))
