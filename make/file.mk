#############################################################
#
# file
#
#############################################################
FILE_SOURCE:=file-3.41.tar.gz
FILE_SITE:=ftp://ftp.astron.com/pub/file
FILE_DIR:=$(BUILD_DIR)/file-3.41
FILE_CAT:=zcat
FILE_BINARY:=file
FILE_TARGET_BINARY:=usr/bin/file

$(DL_DIR)/$(FILE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FILE_SITE)/$(FILE_SOURCE)

file-source: $(DL_DIR)/$(FILE_SOURCE)

$(FILE_DIR)/.unpacked: $(DL_DIR)/$(FILE_SOURCE)
	$(FILE_CAT) $(DL_DIR)/$(FILE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	# Use the system file utility, not the one we just built
	perl -pi -e "s,\./file,file,g" $(FILE_DIR)/Makefile.in $(FILE_DIR)/Makefile.am
	touch $(FILE_DIR)/.unpacked

$(FILE_DIR)/.configured: $(FILE_DIR)/.unpacked
	(cd $(FILE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share/misc \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-nls \
		--enable-fsect-man5 \
	);
	touch  $(FILE_DIR)/.configured

$(FILE_DIR)/$(FILE_BINARY): $(FILE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(FILE_DIR)

$(TARGET_DIR)/$(FILE_TARGET_BINARY): $(FILE_DIR)/$(FILE_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FILE_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

file: zlib uclibc $(TARGET_DIR)/$(FILE_TARGET_BINARY)

file-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(FILE_DIR) uninstall
	-$(MAKE) -C $(FILE_DIR) clean

file-dirclean:
	rm -rf $(FILE_DIR)

