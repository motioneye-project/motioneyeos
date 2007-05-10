#############################################################
#
# libid3tag
#
#############################################################

LIBID3TAG_VERSION=0.15.1b
LIBID3TAG_SOURCE=libid3tag-$(LIBID3TAG_VERSION).tar.gz
LIBID3TAG_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad/
LIBID3TAG_DIR=$(BUILD_DIR)/libid3tag-$(LIBID3TAG_VERSION)
LIBID3TAG_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBID3TAG_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBID3TAG_SITE)/$(LIBID3TAG_SOURCE)

$(LIBID3TAG_DIR)/.unpacked: $(DL_DIR)/$(LIBID3TAG_SOURCE)
	$(LIBID3TAG_CAT) $(DL_DIR)/$(LIBID3TAG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBID3TAG_DIR)/.unpacked

$(LIBID3TAG_DIR)/.configured: $(LIBID3TAG_DIR)/.unpacked
	(cd $(LIBID3TAG_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
	);
	touch $(LIBID3TAG_DIR)/.configured

$(LIBID3TAG_DIR)/libid3tag.la: $(LIBID3TAG_DIR)/.configured
	rm -f $@
	$(MAKE) CC=$(TARGET_CC) -C $(LIBID3TAG_DIR)

$(STAGING_DIR)/usr/lib/libid3tag.so: $(LIBID3TAG_DIR)/libid3tag.la
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBID3TAG_DIR) install

$(TARGET_DIR)/usr/lib/libid3tag.so: $(STAGING_DIR)/usr/lib/libid3tag.so
	cp -dpf $(STAGING_DIR)/usr/lib/libid3tag.so* $(TARGET_DIR)/usr/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libid3tag.so*

libid3tag: uclibc $(TARGET_DIR)/usr/lib/libid3tag.so

libid3tag-source: $(DL_DIR)/$(LIBID3TAG_SOURCE)

libid3tag-clean:
	@if [ -d $(LIBID3TAG_DIR)/Makefile ] ; then \
		$(MAKE) -C $(LIBID3TAG_DIR) clean ; \
	fi;
	rm -f $(STAGING_DIR)/usr/lib/libid3tag.so*


libid3tag-dirclean:
	rm -rf $(LIBID3TAG_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBID3TAG)),y)
TARGETS+=libid3tag
endif
