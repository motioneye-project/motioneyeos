################################################################################
#
# ghostscript-fonts
#
################################################################################

GHOSTSCRIPT_FONTS_VERSION = 8.11
GHOSTSCRIPT_FONTS_SITE = http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29
GHOSTSCRIPT_FONTS_SOURCE = ghostscript-fonts-std-$(GHOSTSCRIPT_FONTS_VERSION).tar.gz
GHOSTSCRIPT_FONTS_LICENSE = GPL-2.0
GHOSTSCRIPT_FONTS_LICENSE_FILES = COPYING

GHOSTSCRIPT_FONTS_TARGET_DIR = $(TARGET_DIR)/usr/share/fonts/gs

define GHOSTSCRIPT_FONTS_INSTALL_TARGET_CMDS
	mkdir -p $(GHOSTSCRIPT_FONTS_TARGET_DIR)
	$(INSTALL) -m 644 $(@D)/*.afm $(GHOSTSCRIPT_FONTS_TARGET_DIR)
	$(INSTALL) -m 644 $(@D)/*.pfb $(GHOSTSCRIPT_FONTS_TARGET_DIR)
endef

$(eval $(generic-package))
