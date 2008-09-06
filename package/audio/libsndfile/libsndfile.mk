#############################################################
#
# libsndfile
#
#############################################################
LIBSNDFILE_VERSION:=1.0.17
LIBSNDFILE_SOURCE:=libsndfile-$(LIBSNDFILE_VERSION).tar.gz
LIBSNDFILE_SITE:=http://www.mega-nerd.com/libsndfile/$(LIBUSB_SOURCE)
LIBSNDFILE_DIR:=$(BUILD_DIR)/libsndfile-$(LIBSNDFILE_VERSION)
LIBSNDFILE_BINARY:=src/.libs/libsndfile.so
LIBSNDFILE_TARGET_BINARY:=usr/lib/libsndfile.so

$(DL_DIR)/$(LIBSNDFILE_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBSNDFILE_SITE)/$(LIBSNDFILE_SOURCE)

$(LIBSNDFILE_DIR)/.unpacked: $(DL_DIR)/$(LIBSNDFILE_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LIBSNDFILE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBSNDFILE_DIR) package/audio/libsndfile/ \*.patch
	$(CONFIG_UPDATE) $(LIBSNDFILE_DIR)
	touch $@

$(LIBSNDFILE_DIR)/.configured: $(LIBSNDFILE_DIR)/.unpacked
	(cd $(LIBSNDFILE_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	)
	touch $@

$(LIBSNDFILE_DIR)/$(LIBSNDFILE_BINARY): $(LIBSNDFILE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBSNDFILE_DIR)

$(TARGET_DIR)/$(LIBSNDFILE_TARGET_BINARY): $(LIBSNDFILE_DIR)/$(LIBSNDFILE_BINARY)
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(LIBSNDFILE_DIR) install
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LIBSNDFILE_DIR) install
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -Rf $(TARGET_DIR)/usr/share/man
	rm -Rf $(STAGING_DIR)/usr/share/man
endif

libsndfile: uclibc $(TARGET_DIR)/$(LIBSNDFILE_TARGET_BINARY)

libsndfile-source: $(DL_DIR)/$(LIBSNDFILE_SOURCE)

libsndfile-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(LIBSNDFILE_DIR) uninstall
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LIBSNDFILE_DIR) uninstall
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
