#############################################################
#
# libglib1.2
#
#############################################################
LIBGLIB12_SOURCE:=glib-1.2.10.tar.gz
LIBGLIB12_SITE:=ftp://ftp.gtk.org/pub/gtk/v1.2
LIBGLIB12_CAT:=zcat
LIBGLIB12_DIR:=$(BUILD_DIR)/glib-1.2.10
LIBGLIB12_BINARY:=libglib-1.2.so.0.0.10

$(DL_DIR)/$(LIBGLIB12_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBGLIB12_SITE)/$(LIBGLIB12_SOURCE)

libglib12-source: $(DL_DIR)/$(LIBGLIB12_SOURCE)

$(LIBGLIB12_DIR)/.unpacked: $(DL_DIR)/$(LIBGLIB12_SOURCE)
	$(LIBGLIB12_CAT) $(DL_DIR)/$(LIBGLIB12_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(LIBGLIB12_DIR)/.unpacked

$(LIBGLIB12_DIR)/.configured: $(LIBGLIB12_DIR)/.unpacked
	(cd $(LIBGLIB12_DIR); rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-nls \
		--enable-shared \
	);
	touch  $(LIBGLIB12_DIR)/.configured

$(LIBGLIB12_DIR)/.libs/$(LIBGLIB12_BINARY): $(LIBGLIB12_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBGLIB12_DIR)

$(STAGING_DIR)/lib/$(LIBGLIB12_BINARY): $(LIBGLIB12_DIR)/.libs/$(LIBGLIB12_BINARY)
	$(MAKE) CC=$(TARGET_CC) prefix=$(STAGING_DIR) -C $(LIBGLIB12_DIR) install

$(TARGET_DIR)/lib/$(LIBGLIB12_BINARY): $(STAGING_DIR)/lib/$(LIBGLIB12_BINARY)
	cp -a $(STAGING_DIR)/lib/$(LIBGLIB12_BINARY) $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libglib.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libglib-1.2.so.0 $(TARGET_DIR)/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/$(LIBGLIB12_BINARY)

libglib12: uclibc $(TARGET_DIR)/lib/$(LIBGLIB12_BINARY)

libglib12-clean:
	rm -f $(TARGET_DIR)/lib/$(LIBGLIB12_BINARY)
	-$(MAKE) -C $(LIBGLIB12_DIR) clean

libglib12-dirclean:
	rm -rf $(LIBGLIB12_DIR)

