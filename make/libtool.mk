#############################################################
#
# libtool
#
#############################################################
LIBTOOL_SOURCE:=libtool-1.4.3.tar.gz
LIBTOOL_SITE:=ftp://ftp.gnu.org/gnu/libtool
LIBTOOL_CAT:=zcat
LIBTOOL_DIR:=$(BUILD_DIR)/libtool-1.4.3
LIBTOOL_BINARY:=libtool
LIBTOOL_TARGET_BINARY:=usr/bin/libtool

$(DL_DIR)/$(LIBTOOL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBTOOL_SITE)/$(LIBTOOL_SOURCE)

libtool-source: $(DL_DIR)/$(LIBTOOL_SOURCE)

$(LIBTOOL_DIR)/.unpacked: $(DL_DIR)/$(LIBTOOL_SOURCE)
	$(LIBTOOL_CAT) $(DL_DIR)/$(LIBTOOL_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(LIBTOOL_DIR)/.unpacked

$(LIBTOOL_DIR)/.configured: $(LIBTOOL_DIR)/.unpacked
	(cd $(LIBTOOL_DIR); rm -f config.cache; CC=$(TARGET_CC1) \
	    CFLAGS=-D_POSIX_SOURCE ./configure \
		--target=i386-uclibc \
		--prefix=/usr \
		--exec-prefix=/usr \
	);
	touch  $(LIBTOOL_DIR)/.configured

$(LIBTOOL_DIR)/$(LIBTOOL_BINARY): $(LIBTOOL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(LIBTOOL_DIR)
	touch -c $(LIBTOOL_DIR)/$(LIBTOOL_BINARY)

$(TARGET_DIR)/$(LIBTOOL_TARGET_BINARY): $(LIBTOOL_DIR)/$(LIBTOOL_BINARY)
	PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    -C $(LIBTOOL_DIR) install;
	rm -rf $(TARGET_DIR)/share/locale

libtool: uclibc $(TARGET_DIR)/$(LIBTOOL_TARGET_BINARY)

libtool-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(LIBTOOL_DIR) uninstall
	-make -C $(LIBTOOL_DIR) clean

libtool-dirclean:
	rm -rf $(LIBTOOL_DIR)

