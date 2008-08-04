#############################################################
#
# ntfs-3g
#
#############################################################
NTFS-3G_VERSION:=1.2506
NTFS-3G_SOURCE:=ntfs-3g-$(NTFS-3G_VERSION).tgz
NTFS-3G_SITE:=www.ntfs-3g.org
NTFS-3G_DIR:=$(BUILD_DIR)/ntfs-3g-$(NTFS-3G_VERSION)
NTFS-3G_BINARY:=ntfs-3g


$(DL_DIR)/$(NTFS-3G_SOURCE):
	$(WGET) -P $(DL_DIR) $(NTFS-3G_SITE)/$(NTFS-3G_SOURCE)

$(NTFS-3G_DIR)/.source: $(DL_DIR)/$(NTFS-3G_SOURCE)
	$(ZCAT) $(DL_DIR)/$(NTFS-3G_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(NTFS-3G_DIR)/.configured: $(NTFS-3G_DIR)/.source
	(cd $(NTFS-3G_DIR); rm -rf config.cache ; \
	$(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--libdir=/usr/lib \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--program-prefix="" \
		--with-gnu-ld \
		--enable-shared \
		--enable-static \
		, \
		ac_cv_path_LDCONFIG=""\
	);
	touch $@

$(NTFS-3G_DIR)/.compiled: $(NTFS-3G_DIR)/.configured
	$(MAKE) prefix=$/usr CC=$(TARGET_CC)-C $(NTFS-3G_DIR)
	touch $@
#		CROSS_COMPILE="$(TARGET_CROSS)"



$(STAGING_DIR)/usr/bin/ntfs-3g: $(NTFS-3G_DIR)/.compiled
	$(MAKE) prefix=$/usr -C $(NTFS-3G_DIR) DESTDIR=$(STAGING_DIR)/ install
	touch -c $@

$(TARGET_DIR)/usr/bin/ntfs-3g: $(STAGING_DIR)/usr/bin/ntfs-3g
	cp -dpf $(STAGING_DIR)/usr/lib/libntfs-3g.so.* $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/usr/bin/ntfs-3g $(TARGET_DIR)/usr/bin/
	touch -c $@

ntfs-3g: uclibc pkgconfig libfuse $(TARGET_DIR)/usr/bin/ntfs-3g

ntfs-3g-source: $(DL_DIR)/$(NTFS-3G_SOURCE)

ntfs-3g-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(NTFS-3G_DIR) uninstall
	rm -f $(TARGET_DIR)/usr/lib/libntfs-3g*
	rm -f $(TARGET_DIR)/usr/bin/ntfs-3g
	-$(MAKE) -C $(NTFS-3G_DIR) clean

ntfs-3g-dirclean:
	rm -rf $(NTFS-3G_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NTFS-3G)),y)
TARGETS+=ntfs-3g
endif
