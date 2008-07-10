#############################################################
#
# libfuse
#
#############################################################
LIBFUSE_VERSION:=2.7.3
LIBFUSE_SOURCE:=fuse-$(LIBFUSE_VERSION).tar.gz
LIBFUSE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/fuse/
LIBFUSE_DIR:=$(BUILD_DIR)/fuse-$(LIBFUSE_VERSION)
LIBFUSE_BINARY:=libfuse
$(DL_DIR)/$(LIBFUSE_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBFUSE_SITE)/$(LIBFUSE_SOURCE)

$(LIBFUSE_DIR)/.source: $(DL_DIR)/$(LIBFUSE_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LIBFUSE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBFUSE_DIR) package/fuse/ \*.patch
	touch $@


$(LIBFUSE_DIR)/.configured: $(LIBFUSE_DIR)/.source
	(cd $(LIBFUSE_DIR); rm -rf config.cache ; \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--enable-shared \
		--enable-static \
		--disable-nls \
		--disable-example \
		--disable-kernel-module \
		--enable-lib \
		--enable-util \
	);
	touch $@

$(LIBFUSE_DIR)/.compiled: $(LIBFUSE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBFUSE_DIR)
	touch $@

$(STAGING_DIR)/usr/lib/libfuse.so: $(LIBFUSE_DIR)/.compiled
	$(MAKE) -C $(LIBFUSE_DIR) DESTDIR=$(STAGING_DIR)/ install
	touch -c $@

$(TARGET_DIR)/usr/lib/libfuse.so: $(STAGING_DIR)/usr/lib/libfuse.so
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/bin
	cp -dpf $(STAGING_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/bin/
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/bin/fusermount
	cp -dpf $(STAGING_DIR)/usr/lib/libfuse.so.* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libfuse.so.*
	touch -c $@

libfuse: uclibc $(TARGET_DIR)/usr/lib/libfuse.so

libfuse-source: $(DL_DIR)/$(LIBFUSE_SOURCE)

libfuse-clean:
	-$(MAKE) -C $(LIBFUSE_DIR) DESTDIR=$(STAGING_DIR) uninstall
	-$(MAKE) -C $(LIBFUSE_DIR) clean
	rm -f $(TARGET_DIR)/usr/bin/fusermount $(TARGET_DIR)/usr/lib/libfuse.so*

libfuse-dirclean:
	rm -rf $(LIBFUSE_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBFUSE)),y)
TARGETS+=libfuse
endif
