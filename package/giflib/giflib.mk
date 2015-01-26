################################################################################
#
# giflib
#
################################################################################

GIFLIB_VERSION = 5.1.1
GIFLIB_SOURCE = giflib-$(GIFLIB_VERSION).tar.bz2
GIFLIB_SITE = http://downloads.sourceforge.net/project/giflib
GIFLIB_INSTALL_STAGING = YES
GIFLIB_LICENSE = MIT
GIFLIB_LICENSE_FILES = COPYING

GIFLIB_BINS = \
	gif2epsn gif2ps gif2rgb gif2x11 gifasm gifbg gifbuild gifburst gifclip \
	gifclrmp gifcolor gifcomb gifcompose gifecho giffiltr giffix gifflip  \
	gifhisto gifinfo gifinter gifinto gifovly gifpos gifrotat     \
	gifrsize gifspnge giftext giftool gifwedge icon2gif raw2gif rgb2gif \
	text2gif

define GIFLIB_BINS_CLEANUP
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(GIFLIB_BINS))
endef

GIFLIB_POST_INSTALL_TARGET_HOOKS += GIFLIB_BINS_CLEANUP

$(eval $(autotools-package))
$(eval $(host-autotools-package))
