################################################################################
#
# font-bh-ttf -- No description available
#
################################################################################

XFONT_FONT_BH_TTF_VERSION = 1.0.0
XFONT_FONT_BH_TTF_SOURCE = font-bh-ttf-$(XFONT_FONT_BH_TTF_VERSION).tar.bz2
XFONT_FONT_BH_TTF_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_BH_TTF_AUTORECONF = NO
XFONT_FONT_BH_TTF_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) MKFONTSCALE=/usr/bin/mkfontscale MKFONTDIR=/usr/bin/mkfontdir FCCACHE=/usr/bin/fc-cache install
XFONT_FONT_BH_TTF_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) MKFONTSCALE=/usr/bin/mkfontscale MKFONTDIR=/usr/bin/mkfontdir FCCACHE=/usr/bin/fc-cache install-data
XFONT_FONT_BH_TTF_DEPENDENCIES = xfont_font-util

$(eval $(call AUTOTARGETS,package/x11r7,xfont_font-bh-ttf))

