#############################################################
#
# make
#
#############################################################
GNUMAKE_SOURCE:=make-3.80.tar.bz2
GNUMAKE_SITE:=ftp://ftp.gnu.org/gnu/make
GNUMAKE_CAT:=bzcat
GNUMAKE_DIR:=$(BUILD_DIR)/make-3.80
GNUMAKE_BINARY:=make
GNUMAKE_TARGET_BINARY:=usr/bin/make

$(DL_DIR)/$(GNUMAKE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GNUMAKE_SITE)/$(GNUMAKE_SOURCE)

make-source: $(DL_DIR)/$(GNUMAKE_SOURCE)

$(GNUMAKE_DIR)/.unpacked: $(DL_DIR)/$(GNUMAKE_SOURCE)
	$(GNUMAKE_CAT) $(DL_DIR)/$(GNUMAKE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(GNUMAKE_DIR)/.unpacked

$(GNUMAKE_DIR)/.configured: $(GNUMAKE_DIR)/.unpacked
	(cd $(GNUMAKE_DIR); autoconf; rm -f config.cache; CC=$(TARGET_CC1) \
	    CFLAGS=-D_POSIX_SOURCE ./configure --prefix=/usr --disable-nls \
	    --mandir=/junk --infodir=/junk \
	);
	touch  $(GNUMAKE_DIR)/.configured

$(GNUMAKE_DIR)/$(GNUMAKE_BINARY): $(GNUMAKE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(GNUMAKE_DIR)

$(TARGET_DIR)/$(GNUMAKE_TARGET_BINARY): $(GNUMAKE_DIR)/$(GNUMAKE_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(GNUMAKE_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/junk

make: uclibc $(TARGET_DIR)/$(GNUMAKE_TARGET_BINARY)

make-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(GNUMAKE_DIR) uninstall
	-make -C $(GNUMAKE_DIR) clean

make-dirclean:
	rm -rf $(GNUMAKE_DIR)

