#############################################################
#
# liblockfile
#
#############################################################
LIBLOCKFILE_VERSION=1.06.1
LIBLOCKFILE_SOURCE:=liblockfile_$(LIBLOCKFILE_VERSION).tar.gz
LIBLOCKFILE_SITE:=http://ftp.debian.org/debian/pool/main/libl/liblockfile/
LIBLOCKFILE_CAT:=$(ZCAT)
LIBLOCKFILE_DIR:=$(BUILD_DIR)/liblockfile-$(LIBLOCKFILE_VERSION)
LIBLOCKFILE_BINARY:=liblockfile.so.1.0

$(DL_DIR)/$(LIBLOCKFILE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBLOCKFILE_SITE)/$(LIBLOCKFILE_SOURCE)

liblockfile-source: $(DL_DIR)/$(LIBLOCKFILE_SOURCE)

$(LIBLOCKFILE_DIR)/.unpacked: $(DL_DIR)/$(LIBLOCKFILE_SOURCE)
	$(LIBLOCKFILE_CAT) $(DL_DIR)/$(LIBLOCKFILE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBLOCKFILE_DIR) package/liblockfile/ \*.patch
	touch $@

$(LIBLOCKFILE_DIR)/.configured: $(LIBLOCKFILE_DIR)/.unpacked
	(cd $(LIBLOCKFILE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--enable-shared \
	);
	touch $@

$(STAGING_DIR)/lib/$(LIBLOCKFILE_BINARY): $(LIBLOCKFILE_DIR)/.configured
	mkdir -p $(STAGING_DIR)/man/man1 $(STAGING_DIR)/man/man3
	$(MAKE) -C $(LIBLOCKFILE_DIR) prefix= ROOT=$(STAGING_DIR) install
	ln -sf $(LIBLOCKFILE_BINARY) $(STAGING_DIR)/lib/liblockfile.so.1
	cp -dpf $(LIBLOCKFILE_DIR)/liblockfile.a $(STAGING_DIR)/lib

$(TARGET_DIR)/usr/lib/$(LIBLOCKFILE_BINARY): $(STAGING_DIR)/lib/$(LIBLOCKFILE_BINARY)
	-mkdir -p $(TARGET_DIR)/usr/lib
	cp -a $(STAGING_DIR)/lib/liblockfile.so* $(TARGET_DIR)/usr/lib
	$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/$(LIBLOCKFILE_BINARY)

liblockfile: uclibc $(TARGET_DIR)/usr/lib/$(LIBLOCKFILE_BINARY)

liblockfile-clean:
	rm -f $(TARGET_DIR)/usr/lib/liblockfile.so*
	rm -f $(STAGING_DIR)/lib/liblockfile*
	rm -f $(STAGING_DIR)/usr/include/lockfile.h
	rm -f $(STAGING_DIR)/usr/include/mailfile.h
	rm -rf $(STAGING_DIR)/man
	$(MAKE) -C $(LIBLOCKFILE_DIR) clean

liblockfile-dirclean:
	rm -rf $(LIBLOCKFILE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBLOCKFILE)),y)
TARGETS+=liblockfile
endif
