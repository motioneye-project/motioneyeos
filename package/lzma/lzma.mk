#############################################################
#
# lzma
#
#############################################################
LZMA_VER:=4.32.0beta3
LZMA_SOURCE:=lzma-$(LZMA_VER).tar.gz
LZMA_SITE:=http://tukaani.org/lzma/
LZMA_DIR:=$(BUILD_DIR)/lzma-$(LZMA_VER)
LZMA_CFLAGS:=$(TARGET_CFLAGS)
ifeq ($(BR2_LARGEFILE),y)
LZMA_CFLAGS+=-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
LZMA_LARGEFILE="--enable-largefile"
else
LZMA_LARGEFILE="--disable-largefile"
endif

$(DL_DIR)/$(LZMA_SOURCE):
	$(WGET) -P $(DL_DIR) $(LZMA_SITE)/$(LZMA_SOURCE)

$(LZMA_DIR)/.source: $(DL_DIR)/$(LZMA_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LZMA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LZMA_DIR) package/lzma/ lzma\*.patch
	touch $(LZMA_DIR)/.source

$(LZMA_DIR)/.configured: $(LZMA_DIR)/.source
	(cd $(LZMA_DIR); rm -f config.cache ;\
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(LZMA_CFLAGS)" \
		ac_cv_func_malloc_0_nonnull=yes \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=$(STAGING_DIR)/usr/bin \
		--libdir=$(STAGING_DIR)/lib \
		--includedir=$(STAGING_DIR)/include \
		--disable-debug \
		$(DISABLE_NLS) \
		$(LZMA_LARGEFILE) \
	);
	touch $(LZMA_DIR)/.configured;

$(LZMA_DIR)/src/lzma/lzma: $(LZMA_DIR)/.configured
	$(MAKE) -C $(LZMA_DIR) all
	touch -c $@

$(STAGING_DIR)/bin/lzma: $(LZMA_DIR)/src/lzma/lzma
	-cp -dpf $(LZMA_DIR)/src/lzma/lzma $(STAGING_DIR)/bin/;
	touch -c $(STAGING_DIR)/bin/lzma

$(TARGET_DIR)/bin/lzma: $(STAGING_DIR)/bin/lzma
	cp -dpf $(STAGING_DIR)/bin/lzma $(TARGET_DIR)/bin/;
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/bin/lzma
	touch -c $(TARGET_DIR)/bin/lzma

#lzma-headers: $(TARGET_DIR)/bin/lzma

lzma: uclibc $(TARGET_DIR)/bin/lzma

lzma-source: $(DL_DIR)/$(LZMA_SOURCE)

lzma-clean:
	rm -f $(TARGET_DIR)/bin/lzma
	-$(MAKE) -C $(LZMA_DIR) clean

lzma-dirclean:
	rm -rf $(LZMA_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LZMA)),y)
TARGETS+=lzma
endif
#ifeq ($(strip $(BR2_PACKAGE_LZMA_TARGET_HEADERS)),y)
#TARGETS+=lzma-headers
#endif
