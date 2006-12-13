#############################################################
#
# dmalloc
#
#############################################################
DMALLOC_VER:=5.4.2
DMALLOC_SOURCE:=dmalloc-$(DMALLOC_VER).tgz
DMALLOC_SITE:=http://dmalloc.com/releases
DMALLOC_DIR:=$(BUILD_DIR)/dmalloc-$(DMALLOC_VER)
DMALLOC_CAT:=$(ZCAT)
DMALLOC_BINARY:=dmalloc
DMALLOC_TARGET_BINARY:=usr/bin/dmalloc

$(DL_DIR)/$(DMALLOC_SOURCE):
	 $(WGET) -P $(DL_DIR) $(DMALLOC_SITE)/$(DMALLOC_SOURCE)

dmalloc-source: $(DL_DIR)/$(DMALLOC_SOURCE)

$(DMALLOC_DIR)/.unpacked: $(DL_DIR)/$(DMALLOC_SOURCE)
	$(DMALLOC_CAT) $(DL_DIR)/$(DMALLOC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(DMALLOC_DIR) package/dmalloc dmalloc\*.patch
	$(SED) 's/^ac_cv_page_size=0$$/ac_cv_page_size=12/' $(DMALLOC_DIR)/configure
	$(SED) 's/(ld -/($${LD-ld} -/' $(DMALLOC_DIR)/configure
	$(SED) 's/'\''ld -/"$${LD-ld}"'\'' -/' $(DMALLOC_DIR)/configure
	touch $(DMALLOC_DIR)/.unpacked

$(DMALLOC_DIR)/.configured: $(DMALLOC_DIR)/.unpacked
	(cd $(DMALLOC_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-g $(TARGET_CFLAGS)" \
		LDFLAGS="-g" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--enable-threads \
		--enable-shlib \
	);
	touch $(DMALLOC_DIR)/.configured

$(DMALLOC_DIR)/$(DMALLOC_BINARY): $(DMALLOC_DIR)/.configured
	$(MAKE) -C $(DMALLOC_DIR)

$(TARGET_DIR)/$(DMALLOC_TARGET_BINARY): $(DMALLOC_DIR)/$(DMALLOC_BINARY)
	$(MAKE)	prefix=$(STAGING_DIR)/usr \
		exec_prefix=$(TARGET_DIR)/usr \
		libdir=$(STAGING_DIR)/usr/lib \
		shlibdir=$(TARGET_DIR)/usr/lib \
		includedir=$(STAGING_DIR)/include \
		-C $(DMALLOC_DIR) install
	(cd $(STAGING_DIR)/usr/lib; \
		mv libdmalloc*.so $(TARGET_DIR)/usr/lib);
	touch $(TARGET_DIR)/$(DMALLOC_TARGET_BINARY)

dmalloc: uclibc $(TARGET_DIR)/$(DMALLOC_TARGET_BINARY)

dmalloc-clean: 
	rm -f $(TARGET_DIR)/usr/lib/libdmalloc*
	rm -f $(STAGING_DIR)/usr/lib/libdmalloc*
	rm -f $(STAGING_DIR)/include/dmalloc.h
	rm -f $(TARGET_DIR)/$(DMALLOC_TARGET_BINARY)
	$(MAKE) -C $(DMALLOC_DIR) clean

dmalloc-dirclean: 
	rm -rf $(DMALLOC_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DMALLOC)),y)
TARGETS+=dmalloc
endif
