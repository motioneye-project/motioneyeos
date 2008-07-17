#############################################################
#
# tiff
#
#############################################################
TIFF_VERSION:=3.8.2
TIFF_SOURCE:=tiff_$(TIFF_VERSION).orig.tar.gz
TIFF_SOURCE2:=tiff-$(TIFF_VERSION).tar.gz
TIFF_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/t/tiff/
TIFF_DIR:=$(BUILD_DIR)/tiff-$(TIFF_VERSION)
TIFF_CAT:=$(ZCAT)

$(DL_DIR)/$(TIFF_SOURCE):
	 $(WGET) -P $(DL_DIR) $(TIFF_SITE)/$(TIFF_SOURCE)

tiff-source: $(DL_DIR)/$(TIFF_SOURCE)

$(TIFF_DIR)/.unpacked: $(DL_DIR)/$(TIFF_SOURCE)
	$(TIFF_CAT) $(DL_DIR)/$(TIFF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(TIFF_CAT) $(TIFF_DIR)/$(TIFF_SOURCE2) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TIFF_DIR) package/tiff/ tiff\*.patch
	$(CONFIG_UPDATE) $(TIFF_DIR)
	$(CONFIG_UPDATE) $(TIFF_DIR)/config
	touch $(TIFF_DIR)/.unpacked

$(TIFF_DIR)/.configured: $(TIFF_DIR)/.unpacked
	(cd $(TIFF_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shared \
		--enable-static \
		--disable-cxx \
		--without-x \
		--with-jpeg-include-dir=$(STAGING_DIR)/usr/include \
		--with-jpeg-lib-dir=$(STAGING_DIR)/lib \
		--with-zlib-include-dir=$(STAGING_DIR)/usr/include \
		--with-zlib-lib-dir=$(STAGING_DIR)/lib \
	)
	touch $(TIFF_DIR)/.configured

$(TIFF_DIR)/libtiff/.libs/libtiff.a: $(TIFF_DIR)/.configured
	$(MAKE) -C $(TIFF_DIR)
	touch -c $@

$(STAGING_DIR)/usr/lib/libtiff.so: $(TIFF_DIR)/libtiff/.libs/libtiff.a
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(TIFF_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libtiff.la
	touch -c $@

$(TARGET_DIR)/usr/lib/libtiff.so: $(STAGING_DIR)/usr/lib/libtiff.so
	cp -dpf $(STAGING_DIR)/usr/lib/libtiff.so* $(TARGET_DIR)/usr/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@

tiff: uclibc zlib jpeg $(TARGET_DIR)/usr/lib/libtiff.so

tiff-clean:
	-rm -f $(TARGET_DIR)/usr/lib/libtiff.so*
	-$(MAKE) -C $(TIFF_DIR) DESTDIR=$(STAGING_DIR) uninstall
	-$(MAKE) -C $(TIFF_DIR) clean

tiff-dirclean:
	rm -rf $(TIFF_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_TIFF)),y)
TARGETS+=tiff
endif
