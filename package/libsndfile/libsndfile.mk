#############################################################
#
# libsndfile
#
#############################################################
LIBSNDFILE_VER:=1.0.17
LIBSNDFILE_SOURCE:=libsndfile-$(LIBSNDFILE_VER).tar.gz
LIBSNDFILE_SITE:=http://www.mega-nerd.com/libsndfile/$(LIBUSB_SOURCE)
LIBSNDFILE_DIR:=$(BUILD_DIR)/libsndfile-$(LIBSNDFILE_VER)
LIBSNDFILE_BINARY:=src/.libs/libsndfile.so
LIBSNDFILE_TARGET_BINARY:=usr/lib/libsndfile.so

$(DL_DIR)/$(LIBSNDFILE_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBSNDFILE_SITE)/$(LIBSNDFILE_SOURCE)

$(LIBSNDFILE_DIR)/.unpacked: $(DL_DIR)/$(LIBSNDFILE_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LIBSNDFILE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBSNDFILE_DIR) package/libsndfile/ \*.patch
	$(CONFIG_UPDATE) $(LIBSNDFILE_DIR)
	touch $@

$(LIBSNDFILE_DIR)/.configured: $(LIBSNDFILE_DIR)/.unpacked
	(cd $(LIBSNDFILE_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	);
	touch $@

$(LIBSNDFILE_DIR)/$(LIBSNDFILE_BINARY): $(LIBSNDFILE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBSNDFILE_DIR)

$(TARGET_DIR)/$(LIBSNDFILE_TARGET_BINARY): $(LIBSNDFILE_DIR)/$(LIBSNDFILE_BINARY)
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LIBSNDFILE_DIR) install
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(LIBSNDFILE_DIR) install
	rm -Rf $(TARGET_DIR)/usr/man

libsndfile: uclibc $(TARGET_DIR)/$(LIBSNDFILE_TARGET_BINARY)

libsndfile-source: $(DL_DIR)/$(LIBSNDFILE_SOURCE)

libsndfile-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LIBSNDFILE_DIR) uninstall
	-$(MAKE) prefix=$(STAGING_DIR)/usr -C $(LIBSNDFILE_DIR) uninstall
	-$(MAKE) -C $(LIBSNDFILE_DIR) clean

libsndfile-dirclean:
	rm -rf $(LIBSNDFILE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBSNDFILE)),y)
TARGETS+=libsndfile
endif

