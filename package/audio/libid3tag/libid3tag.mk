#############################################################
#
# libid3tag
#
#############################################################

LIBID3TAG_VERSION:=0.15.1b
LIBID3TAG_SOURCE:=libid3tag-$(LIBID3TAG_VERSION).tar.gz
LIBID3TAG_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mad
LIBID3TAG_DIR:=$(BUILD_DIR)/libid3tag-$(LIBID3TAG_VERSION)
LIBID3TAG_CAT:=$(ZCAT)
LIBID3TAG_BIN:=libid3tag.so.0.3.0
LIBID3TAG_TARGET_BIN:=usr/lib/$(LIBID3TAG_BIN)

$(DL_DIR)/$(LIBID3TAG_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBID3TAG_SITE)/$(LIBID3TAG_SOURCE)

$(LIBID3TAG_DIR)/.unpacked: $(DL_DIR)/$(LIBID3TAG_SOURCE)
	$(LIBID3TAG_CAT) $(DL_DIR)/$(LIBID3TAG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBID3TAG_DIR) package/libid3tag/ libid3tag-$(LIBID3TAG_VERSION)\*.patch\*
	$(CONFIG_UPDATE) $(LIBID3TAG_DIR)
	touch $@

$(LIBID3TAG_DIR)/.configured: $(LIBID3TAG_DIR)/.unpacked
	(cd $(LIBID3TAG_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		$(DISABLE_NLS) \
	)
	touch $@

$(LIBID3TAG_DIR)/.libs/$(LIBID3TAG_BIN): $(LIBID3TAG_DIR)/.configured
	$(MAKE) -C $(LIBID3TAG_DIR)

$(STAGING_DIR)/$(LIBID3TAG_TARGET_BIN): $(LIBID3TAG_DIR)/.libs/$(LIBID3TAG_BIN)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBID3TAG_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libid3tag.la

$(TARGET_DIR)/$(LIBID3TAG_TARGET_BIN): $(STAGING_DIR)/$(LIBID3TAG_TARGET_BIN)
	cp -dpf $(STAGING_DIR)/usr/lib/libid3tag.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libid3tag.so*

libid3tag: uclibc zlib libmad $(TARGET_DIR)/$(LIBID3TAG_TARGET_BIN)

libid3tag-source: $(DL_DIR)/$(LIBID3TAG_SOURCE)

libid3tag-clean:
	-$(MAKE) -C $(LIBID3TAG_DIR) clean
	rm -f $(STAGING_DIR)/$(LIBID3TAG_TARGET_BIN)
	rm -f $(TARGET_DIR)/$(LIBID3TAG_TARGET_BIN) \
		$(TARGET_DIR)/usr/lib/libid3tag*

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
