#############################################################
#
# tar
#
#############################################################
GNUTAR_SOURCE:=tar-1.13.25.tar.gz
GNUTAR_SITE:=ftp://alpha.gnu.org/gnu/tar
GNUTAR_DIR:=$(BUILD_DIR)/tar-1.13.25
GNUTAR_CAT:=zcat
GNUTAR_BINARY:=src/tar
GNUTAR_TARGET_BINARY:=bin/tar

$(DL_DIR)/$(GNUTAR_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GNUTAR_SITE)/$(GNUTAR_SOURCE)

tar-source: $(DL_DIR)/$(GNUTAR_SOURCE)

$(GNUTAR_DIR)/.unpacked: $(DL_DIR)/$(GNUTAR_SOURCE)
	$(GNUTAR_CAT) $(DL_DIR)/$(GNUTAR_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(GNUTAR_DIR)/.unpacked

$(GNUTAR_DIR)/.configured: $(GNUTAR_DIR)/.unpacked
	(cd $(GNUTAR_DIR); rm -rf config.cache; \
		PATH=$(TARGET_PATH) CC=$(TARGET_CC) \
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
	);
	touch  $(GNUTAR_DIR)/.configured

$(GNUTAR_DIR)/$(GNUTAR_BINARY): $(GNUTAR_DIR)/.configured
	$(MAKE) -C $(GNUTAR_DIR)

$(TARGET_DIR)/$(GNUTAR_TARGET_BINARY): $(GNUTAR_DIR)/$(GNUTAR_BINARY)
	rm -f $(TARGET_DIR)/$(GNUTAR_TARGET_BINARY)
	cp -a $(GNUTAR_DIR)/$(GNUTAR_BINARY) $(TARGET_DIR)/$(GNUTAR_TARGET_BINARY)

tar: uclibc $(TARGET_DIR)/$(GNUTAR_TARGET_BINARY)

tar-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(GNUTAR_DIR) uninstall
	-$(MAKE) -C $(GNUTAR_DIR) clean

tar-dirclean:
	rm -rf $(GNUTAR_DIR)

