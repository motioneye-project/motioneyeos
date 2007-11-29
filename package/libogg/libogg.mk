#############################################################
#
# libogg
#
#############################################################
LIBOGG_VERSION:=1.1.3
LIBOGG_NAME:=libogg-$(LIBOGG_VERSION)
LIBOGG_SOURCE:=$(LIBOGG_NAME).tar.gz
LIBOGG_SITE:=http://downloads.xiph.org/releases/ogg/$(LIBOGG-SOURCE)
LIBOGG_DIR:=$(BUILD_DIR)/libogg-$(LIBOGG_VERSION)
LIBOGG_BINARY:=libogg
LIBOGG_TARGET_BINARY:=usr/lib/libogg
LIBOGG_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBOGG_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBOGG_SITE)/$(LIBOGG_SOURCE)

$(LIBOGG_DIR)/.source: $(DL_DIR)/$(LIBOGG_SOURCE)
	$(LIBOGG_CAT) $(DL_DIR)/$(LIBOGG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LIBOGG_DIR)/.configured: $(LIBOGG_DIR)/.source
	(cd $(LIBOGG_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/lib/pkconfig:$(STAGING_DIR)/usr/lib/pkgconfig" \
		PKG_CONFIG="$(STAGING_DIR)/usr/bin/pkg-config" \
		PKG_CONFIG_SYSROOT=$(STAGING_DIR) \
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
	)
	touch $@

$(LIBOGG_DIR)/.libs: $(LIBOGG_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(LIBOGG_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libogg.so: $(LIBOGG_DIR)/.libs
	mkdir -p $(STAGING_DIR)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBOGG_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libogg.la

$(TARGET_DIR)/usr/lib/libogg.so: $(STAGING_DIR)/usr/lib/libogg.so
	cp -dpf $(STAGING_DIR)/usr/lib/libogg.so* $(TARGET_DIR)/usr/lib
ifneq ($(strip $(BR2_HAVE_MANPAGES)),y)
	rm -rf $(TARGET_DIR)/usr/share/doc/$(LIBOGG_NAME)
endif
	touch $@

$(TARGET_DIR)/usr/lib/libogg.a: $(TARGET_DIR)/usr/lib/libogg.so
	cp -dpf $(LIBOGG_DIR)/lib/libogg.a $(TARGET_DIR)/usr/lib/
	touch $@

libogg-header: $(TARGET_DIR)/usr/lib/libogg.a
	mkdir -p $(TARGET_DIR)/usr/include/ogg
	cp -dpf $(LIBOGG_DIR)/include/ogg/*.h \
		$(TARGET_DIR)/usr/include/ogg

libogg: uclibc pkgconfig $(TARGET_DIR)/usr/lib/libogg.so

libogg-source: $(DL_DIR)/$(LIBOGG_SOURCE)

libogg-clean:
	-rm -rf $(TARGET_DIR)/usr/lib/libogg.so*
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBOGG_DIR) uninstall
	-$(MAKE) -C $(LIBOGG_DIR) clean

libogg-dirclean:
	rm -rf $(LIBOGG_DIR)

############################################################
#
# Toplevel Makefile options
#
############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBOGG)),y)
TARGETS+=libogg
endif

ifeq ($(strip $(BR2_PACKAGE_LIBOGG_HEADERS)),y)
TARGETS+=libogg-header
endif
