#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION:=2.1.9
FREETYPE_SOURCE:=freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_CAT:=$(BZCAT)
FREETYPE_DIR:=$(BUILD_DIR)/freetype-$(FREETYPE_VERSION)

$(DL_DIR)/$(FREETYPE_SOURCE):
	$(WGET) -P $(DL_DIR) $(FREETYPE_SITE)/$(FREETYPE_SOURCE)

freetype-source: $(DL_DIR)/$(FREETYPE_SOURCE)

$(FREETYPE_DIR)/.unpacked: $(DL_DIR)/$(FREETYPE_SOURCE)
	$(FREETYPE_CAT) $(DL_DIR)/$(FREETYPE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(FREETYPE_DIR)/.unpacked

$(FREETYPE_DIR)/.configured: $(FREETYPE_DIR)/.unpacked
	(cd $(FREETYPE_DIR); \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS) " \
	./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--prefix=$(STAGING_DIR)/usr );
	touch $(FREETYPE_DIR)/.configured

$(FREETYPE_DIR)/.compiled: $(FREETYPE_DIR)/.configured
	$(MAKE) -C $(FREETYPE_DIR) 
	touch $(FREETYPE_DIR)/.compiled

$(STAGING_DIR)/usr/lib/libfreetype.so: $(FREETYPE_DIR)/.compiled
	$(MAKE) -C $(FREETYPE_DIR) install
	touch -c $(STAGING_DIR)/lib/libfreetype.so

$(TARGET_DIR)/usr/lib/libfreetype.so: $(STAGING_DIR)/usr/lib/libfreetype.so
	cp -dpf $(STAGING_DIR)/usr/lib/libfreetype.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libfreetype.so

freetype: uclibc $(TARGET_DIR)/usr/lib/libfreetype.so

freetype-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FREETYPE_DIR) uninstall
	-$(MAKE) -C $(FREETYPE_DIR) clean

freetype-dirclean:
	rm -rf $(FREETYPE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FREETYPE)),y)
TARGETS+=freetype
endif
