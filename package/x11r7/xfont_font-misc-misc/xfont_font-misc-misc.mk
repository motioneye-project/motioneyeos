################################################################################
#
# font-misc-misc -- No description available
#
################################################################################

XFONT_FONT_MISC_MISC_VERSION = 1.1.0
XFONT_FONT_MISC_MISC_SOURCE = font-misc-misc-$(XFONT_FONT_MISC_MISC_VERSION).tar.bz2
XFONT_FONT_MISC_MISC_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_MISC_MISC_AUTORECONF = NO
XFONT_FONT_MISC_MISC_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/usr/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/usr/bin/mkfontdir install
XFONT_FONT_MISC_MISC_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/usr/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/usr/bin/mkfontdir install-data
XFONT_FONT_MISC_MISC_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_mkfontdir host-xapp_bdftopcf

define XFONT_FONT_MISC_MISC_MAPFILES_PATH_FIX
	$(SED) 's|UTIL_DIR = |UTIL_DIR = $(STAGING_DIR)|' $(@D)/Makefile
endef

XFONT_FONT_MISC_MISC_POST_CONFIGURE_HOOKS += XFONT_FONT_MISC_MISC_MAPFILES_PATH_FIX

$(eval $(call AUTOTARGETS,package/x11r7,xfont_font-misc-misc))

