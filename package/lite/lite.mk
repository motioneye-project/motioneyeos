#############################################################
#
# LiTE
#
#############################################################
LITE_VERSION:=0.8.10
LITE_SOURCE:=LiTE-$(LITE_VERSION).tar.gz
LITE_SITE:=http://www.directfb.org/downloads/Libs
LITE_INSTALL_STAGING = YES
LITE_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install
LITE_CONF_ENV = DFB_CFLAGS=-I$(STAGING_DIR)/usr/include/directfb
LITE_DEPENDENCIES = directfb

define LITE_FINALIZE_INSTALL
	$(INSTALL) -d $(TARGET_DIR)/usr/share/LiTE/examples/
	$(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/truetype/
	$(INSTALL) -m0644 $(@D)/data/*.png $(TARGET_DIR)/usr/share/LiTE/
	$(INSTALL) -m0644 $(@D)/examples/*.png $(TARGET_DIR)/usr/share/LiTE/examples/
	$(INSTALL) -m0644 $(@D)/fonts/*.ttf $(TARGET_DIR)/usr/share/fonts/truetype/
endef

LITE_POST_INSTALL_TARGET_HOOKS += LITE_FINALIZE_INSTALL

$(eval $(autotools-package))
