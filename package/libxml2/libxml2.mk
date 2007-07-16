#############################################################
#
# libxml2
#
#############################################################

LIBXML2_VERSION=2.6.29
LIBXML2_SOURCE=libxml2-sources-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE=ftp://xmlsoft.org/libxml2
LIBXML2_DIR=$(BUILD_DIR)/libxml2-$(LIBXML2_VERSION)
LIBXML2_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBXML2_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBXML2_SITE)/$(LIBXML2_SOURCE)

$(LIBXML2_DIR)/.unpacked: $(DL_DIR)/$(LIBXML2_SOURCE)
	$(LIBXML2_CAT) $(DL_DIR)/$(LIBXML2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBXML2_DIR)/.unpacked

$(LIBXML2_DIR)/.configured: $(LIBXML2_DIR)/.unpacked
	(cd $(LIBXML2_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		$(DISABLE_NLS) \
	);
	touch $(LIBXML2_DIR)/.configured

$(LIBXML2_DIR)/libxml2.la: $(LIBXML2_DIR)/.configured
	rm -f $@
	$(MAKE) CC=$(TARGET_CC) -C $(LIBXML2_DIR)

$(STAGING_DIR)/usr/lib/libxml2.so: $(LIBXML2_DIR)/libxml2.la
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBXML2_DIR) install

$(TARGET_DIR)/usr/lib/libxml2.so: $(STAGING_DIR)/usr/lib/libxml2.so
	cp -dpf $(STAGING_DIR)/usr/lib/libxml2.so* $(TARGET_DIR)/usr/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libxml2.so*

$(TARGET_DIR)/usr/lib/libxml2.a: $(STAGING_DIR)/usr/lib/libxml2.so
	mkdir -p $(TARGET_DIR)/usr/include
	cp -dpf $(STAGING_DIR)/usr/lib/libxml2.*a $(TARGET_DIR)/usr/lib/
#	cp -dpf $(STAGING_DIR)/usr/include/mad.h $(TARGET_DIR)/usr/include/

libxml2:	uclibc $(TARGET_DIR)/usr/lib/libxml2.so

libxml2-headers: $(TARGET_DIR)/usr/lib/libxml2.a

libxml2-source: $(DL_DIR)/$(LIBXML2_SOURCE)

libxml2-clean:
	@if [ -d $(LIBXML2_DIR)/Makefile ] ; then \
		$(MAKE) -C $(LIBXML2_DIR) clean ; \
	fi;
	rm -f $(STAGING_DIR)/usr/lib/libxml2.*
	rm -f $(TARGET_DIR)/usr/lib/libxml2.*


libxml2-dirclean:
	rm -rf $(LIBXML2_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBXML2)),y)
TARGETS+=libxml2
endif
ifeq ($(strip $(BR2_PACKAGE_LIBXML2_TARGET_HEADERS)),y)
TARGETS+=libxml2-headers
endif
