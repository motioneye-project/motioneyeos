#############################################################
#
# libvorbis
#
#############################################################
LIBVORBIS_VERSION:=1.2.0
LIBVORBIS_SOURCE:=libvorbis-$(LIBVORBIS_VERSION).tar.gz
LIBVORBIS_SITE:=http://downloads.xiph.org/releases/vorbis/$(LIBVORBIS-SOURCE)
LIBVORBIS_DIR:=$(BUILD_DIR)/libvorbis-$(LIBVORBIS_VERSION)
LIBVORBIS_BINARY:=libvorbis
LIBVORBIS_TARGET_BINARY:=usr/bin/libvorbis
LIBVORBIS_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBVORBIS_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBVORBIS_SITE)/$(LIBVORBIS_SOURCE)

$(LIBVORBIS_DIR)/.source: $(DL_DIR)/$(LIBVORBIS_SOURCE)
	$(LIBVORBIS_CAT) $(DL_DIR)/$(LIBVORBIS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LIBVORBIS_DIR)/.configured: $(LIBVORBIS_DIR)/.source
	(cd $(LIBVORBIS_DIR); rm -rf config.cache ; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/lib/pkconfig:$(STAGING_DIR)/usr/lib/pkgconfig" PKG_CONFIG="$(STAGING_DIR)/usr/bin/pkg-config" PKG_CONFIG_SYSROOT=$(STAGING_DIR) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--enable-static \
		--disable-oggtest \
		$(DISABLE_NLS) \
	);
	touch $@

$(LIBVORBIS_DIR)/.libs: $(LIBVORBIS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBVORBIS_DIR)
	touch $@

$(TARGET_DIR)/usr/lib/libvorbis.so: $(LIBVORBIS_DIR)/.libs
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LIBVORBIS_DIR) install
	touch $@

$(TARGET_DIR)/usr/lib/libvorbis.a: $(TARGET_DIR)/usr/lib/libvorbis.so
	cp -dpf $(LIBVORBIS_DIR)/lib/libvorbis.a $(TARGET_DIR)/usr/lib/
	touch $@

libvorbis-header: $(TARGET_DIR)/usr/lib/libvorbis.a
	mkdir -p $(TARGET_DIR)/usr/include/vorbis
	cp -dpf $(LIBVORBIS_DIR)/include/vorbis/*.h $(TARGET_DIR)/usr/include/vorbis

libvorbis: uclibc pkgconfig $(TARGET_DIR)/usr/lib/libvorbis.so

libvorbis-source: $(DL_DIR)/$(LIBVORBIS_SOURCE)

libvorbis-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(LIBVORBIS_DIR) uninstall
	-$(MAKE) -C $(LIBVORBIS_DIR) clean

libvorbis-dirclean:
	rm -rf $(LIBVORBIS_DIR)

############################################################
#
# Tremor (Integer decoder for Vorbis)
#
############################################################

TREMOR_TRUNK:=http://svn.xiph.org/trunk/Tremor/
TREMOR_VERSION:=-svn-$(DATE)
TREMOR_NAME:=Tremor-$(TREMOR_VERSION)
TREMOR_DIR:=$(BUILD_DIR)/$(TREMOR_NAME)
TREMOR_SOURCE:=$(TREMOR_NAME).tar.bz2


$(DL_DIR)/$(TREMOR_SOURCE):
	(cd $(BUILD_DIR) ; \
	svn co $(TREMOR_TRUNK) ; \
	mv -af Tremor $(TREMOR_NAME) ; \ 
	tar -cvf $(TREMOR_NAME).tar $(TREMOR_DIR); \
	bzip2 $(TREMOR_NAME).tar ; \
	rm -fr $(TREMOR_DIR) ; \
	mv $(TREMOR_NAME).tar.bz2 $(DL_DIR)/$(TREMOR_SOURCE) ; \
	)

$(TREMOR_DIR)/.source: $(DL_DIR)/$(TREMOR_SOURCE)
	$(TREMOR_CAT) $(DL_DIR)/$(TREMOR_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(TREMOR_DIR)/.configured: $(TREMOR_DIR)/.source
	(cd $(TREMOR_DIR); rm -rf config.cache ; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/lib/pkconfig:$(STAGING_DIR)/usr/lib/pkgconfig" PKG_CONFIG="$(STAGING_DIR)/usr/bin/pkg-config" PKG_CONFIG_SYSROOT=$(STAGING_DIR) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--enable-static \
		--disable-oggtest \
		$(DISABLE_NLS) \
	);
	touch $@

$(TREMOR_DIR)/.libs: $(TREMOR_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(TREMOR_DIR)
	touch $@

$(TARGET_DIR)/usr/lib/tremor.so: $(TREMOR_DIR)/.libs
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(TREMOR_DIR) install
	touch $@

$(TARGET_DIR)/usr/lib/tremor.a: $(TARGET_DIR)/usr/lib/tremor.so
	cp -dpf $(TREMOR_DIR)/lib/tremor.a $(TARGET_DIR)/usr/lib/
	touch $@

tremor-header: $(TARGET_DIR)/usr/lib/tremor.a
	mkdir -p $(TARGET_DIR)/usr/include/vorbis
	cp -dpf $(TREMOR_DIR)/include/vorbis/*.h $(TARGET_DIR)/usr/include/vorbis

tremor: uclibc pkgconfig $(TARGET_DIR)/usr/lib/tremor.so

tremor-source: $(DL_DIR)/$(TREMOR_SOURCE)

tremor-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(TREMOR_DIR) uninstall
	-$(MAKE) -C $(TREMOR_DIR) clean

tremor-dirclean:
	rm -rf $(TREMOR_DIR)


############################################################
#
# Toplevel Makefile options
#
############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBVORBIS)),y)
ifeq ($(strip $(BR2_PACKAGE_LIBVORBIS)),y)
TARGETS+=tremor
else
TARGETS+=libvorbis
endif
endif

ifeq ($(strip $(BR2_PACKAGE_LIBVORBIS_HEADERS)),y)
 TARGETS+=libvorbis-header
endif

