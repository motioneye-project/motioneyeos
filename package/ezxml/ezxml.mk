#############################################################
#
# ezxml
#
#############################################################

EZXML_VERSION:=0.8.6
EZXML_SOURCE:=ezxml-$(EZXML_VERSION).tar.gz
EZXML_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ezxml/
EZXML_DIR:=$(BUILD_DIR)/ezxml

$(DL_DIR)/$(EZXML_SOURCE):
	$(WGET) -P $(DL_DIR) $(EZXML_SITE)/$(EZXML_SOURCE)

$(EZXML_DIR)/.unpacked: $(DL_DIR)/$(EZXML_SOURCE)
	$(ZCAT) $(DL_DIR)/$(EZXML_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(EZXML_DIR) package/ezxml/ ezxml-$(EZXML_VERSION)\*.patch
	touch $@

$(EZXML_DIR)/.configured: $(EZXML_DIR)/.unpacked
	touch $@

$(EZXML_DIR)/libezxml.a: $(EZXML_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" AR=$(TARGET_AR) \
	-f GNUmakefile -C $(EZXML_DIR)

$(STAGING_DIR)/usr/lib/libezxml.a: $(EZXML_DIR)/libezxml.a
	cp $(EZXML_DIR)/ezxml.h $(STAGING_DIR)/usr/include
	cp $(EZXML_DIR)/libezxml.a $(STAGING_DIR)/usr/lib

ezxml: uclibc $(STAGING_DIR)/usr/lib/libezxml.a

ezxml-source: $(DL_DIR)/$(EZXML_SOURCE)

ezxml-clean:
	-$(MAKE) -C $(EZXML_DIR) -f GNUmakefile clean

ezxml-dirclean:
	rm -rf $(EZXML_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_EZXML),y)
TARGETS+=ezxml
endif
