#############################################################
#
# sed
#
#############################################################
SED_SOURCE:=sed-3.02.tar.gz
SED_SITE:=ftp://ftp.gnu.org/gnu/sed
SED_CAT:=zcat
SED_DIR:=$(BUILD_DIR)/sed-3.02
SED_BINARY:=sed/sed
SED_TARGET_BINARY:=bin/sed

$(DL_DIR)/$(SED_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SED_SITE)/$(SED_SOURCE)

sed-source: $(DL_DIR)/$(SED_SOURCE)

$(SED_DIR)/.unpacked: $(DL_DIR)/$(SED_SOURCE)
	$(SED_CAT) $(DL_DIR)/$(SED_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(SED_DIR)/.unpacked

$(SED_DIR)/.configured: $(SED_DIR)/.unpacked
	(cd $(SED_DIR); autoconf; rm -f config.cache; CC=$(TARGET_CC1) \
	    CFLAGS=-D_POSIX_SOURCE ./configure --prefix=/usr --disable-nls \
	    --mandir=/junk --infodir=/junk \
	);
	touch  $(SED_DIR)/.configured

$(SED_DIR)/$(SED_BINARY): $(SED_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(SED_DIR)

$(TARGET_DIR)/$(SED_TARGET_BINARY): $(SED_DIR)/$(SED_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(SED_DIR) install
	mv $(TARGET_DIR)/usr/bin/sed $(TARGET_DIR)/bin/
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/junk

sed: uclibc $(TARGET_DIR)/$(SED_TARGET_BINARY)

sed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(SED_DIR) uninstall
	-sed -C $(SED_DIR) clean

sed-dirclean:
	rm -rf $(SED_DIR)

