#############################################################
#
# liblockfile
#
#############################################################
LIBLOCKFILE_VERSION=1.08
LIBLOCKFILE_SOURCE:=liblockfile_$(LIBLOCKFILE_VERSION).orig.tar.gz
LIBLOCKFILE_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/libl/liblockfile/
LIBLOCKFILE_CAT:=$(ZCAT)
LIBLOCKFILE_DIR:=$(BUILD_DIR)/liblockfile-$(LIBLOCKFILE_VERSION)
LIBLOCKFILE_BINARY:=usr/lib/liblockfile.so.1.0

$(DL_DIR)/$(LIBLOCKFILE_SOURCE):
	 $(call DOWNLOAD,$(LIBLOCKFILE_SITE),$(LIBLOCKFILE_SOURCE))

liblockfile-source: $(DL_DIR)/$(LIBLOCKFILE_SOURCE)

$(LIBLOCKFILE_DIR)/.unpacked: $(DL_DIR)/$(LIBLOCKFILE_SOURCE)
	$(LIBLOCKFILE_CAT) $(DL_DIR)/$(LIBLOCKFILE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBLOCKFILE_DIR) package/liblockfile/ \*.patch
	touch $@

$(LIBLOCKFILE_DIR)/.configured: $(LIBLOCKFILE_DIR)/.unpacked
	(cd $(LIBLOCKFILE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure $(QUIET) \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--bindir=/usr/bin \
		--libdir=/usr/lib \
		--includedir=/usr/include \
		--mandir=/usr/share/man \
		--enable-shared \
	)
	touch $@

$(STAGING_DIR)/$(LIBLOCKFILE_BINARY): $(LIBLOCKFILE_DIR)/.configured
	mkdir -p $(addprefix $(STAGING_DIR)/usr/share/man/man,1 3)
	rm -f $(STAGING_DIR)/usr/lib/liblockfile.so
	$(MAKE) -C $(LIBLOCKFILE_DIR) ROOT=$(STAGING_DIR) install
	ln -sf liblockfile.so $(STAGING_DIR)/usr/lib/liblockfile.so.1
	touch -c $@

$(TARGET_DIR)/$(LIBLOCKFILE_BINARY): $(STAGING_DIR)/$(LIBLOCKFILE_BINARY)
	mkdir -p $(@D)
	cp -a $(STAGING_DIR)/usr/lib/liblockfile.so* $(@D)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@
	touch -c $@

liblockfile: $(TARGET_DIR)/$(LIBLOCKFILE_BINARY)

liblockfile-clean:
	rm -f $(TARGET_DIR)/usr/lib/liblockfile.so*
	rm -f $(STAGING_DIR)/usr/lib/liblockfile*
	rm -f $(addprefix $(STAGING_DIR)/usr/include/,lockfile.h mailfile.h)
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(STAGING_DIR)/usr/share/man
endif
	-$(MAKE) -C $(LIBLOCKFILE_DIR) clean

liblockfile-dirclean:
	rm -rf $(LIBLOCKFILE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_LIBLOCKFILE),y)
TARGETS+=liblockfile
endif
