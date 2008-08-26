#############################################################
#
# LiTE
#
#############################################################
LITE_VERSION:=0.8.9
LITE_SOURCE:=LiTE-$(LITE_VERSION).tar.gz
LITE_SITE:=http://www.directfb.org/downloads/Libs
LITE_AUTORECONF = NO
LITE_INSTALL_STAGING = YES
LITE_INSTALL_TARGET = YES
LITE_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install
LITE_CONF_ENV = DFB_CFLAGS=-I$(STAGING_DIR)/usr/include/directfb
LITE_CONF_OPT =
LITE_DEPENDENCIES = directfb

$(eval $(call AUTOTARGETS,package,lite))

$(LITE_HOOK_POST_INSTALL):
	$(INSTALL) -d $(TARGET_DIR)/usr/share/LiTE/examples/
	$(INSTALL) -d $(TARGET_DIR)/usr/share/fonts/truetype
	$(INSTALL) -m0644 $(LITE_DIR)/data/*.png $(TARGET_DIR)/usr/share/LiTE/
	$(INSTALL) -m0644 $(LITE_DIR)/examples/*.png $(TARGET_DIR)/usr/share/LiTE/examples/
	$(INSTALL) -m0644 $(LITE_DIR)/fonts/*.ttf $(TARGET_DIR)/usr/share/fonts/truetype/ 
	touch $@