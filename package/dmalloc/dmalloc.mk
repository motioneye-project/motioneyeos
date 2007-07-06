#############################################################
#
# dmalloc
#
#############################################################
DMALLOC_VER:=5.4.3
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
	-$(SED) 's/ar cr/$$(AR) cr/' $(DMALLOC_DIR)/Makefile.in
	touch $@

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
DMALLOC_CONFIG_ARGS:=--enable-cxx
else
DMALLOC_CONFIG_ARGS:=--disable-cxx
endif

ifeq ($(BR2_PTHREADS_NONE),y)
DMALLOC_CONFIG_ARGS+=--disable-threads
else
DMALLOC_CONFIG_ARGS+=--enable-threads
endif



$(DMALLOC_DIR)/.configured: $(DMALLOC_DIR)/.unpacked
	(cd $(DMALLOC_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="-g" \
		LDFLAGS="-g" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shlib \
		$(DMALLOC_CONFIG_ARGS) \
	);
	touch $@

$(DMALLOC_DIR)/$(DMALLOC_BINARY): $(DMALLOC_DIR)/.configured
	$(MAKE) -C $(DMALLOC_DIR)

$(TARGET_DIR)/$(DMALLOC_TARGET_BINARY): $(DMALLOC_DIR)/$(DMALLOC_BINARY)
	# both DESTDIR and PREFIX are ignored..
	$(MAKE)	includedir="$(STAGING_DIR)/usr/include" \
		bindir="$(STAGING_DIR)/usr/bin" \
		libdir="$(STAGING_DIR)/usr/lib" \
		shlibdir="$(STAGING_DIR)/usr/lib" \
		includedir="$(STAGING_DIR)/usr/share/info/" \
		-C $(DMALLOC_DIR) install
	(cd $(STAGING_DIR)/usr/lib; \
		mv libdmalloc*.so $(TARGET_DIR)/usr/lib);
	cp -dpf $(STAGING_DIR)/usr/bin/dmalloc $(TARGET_DIR)/$(DMALLOC_TARGET_BINARY)
	$(STRIP) -s $(TARGET_DIR)/$(DMALLOC_TARGET_BINARY)

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
