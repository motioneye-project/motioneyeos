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
	(cd $(SED_DIR); rm -rf config.cache; \
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
	touch  $(SED_DIR)/.configured

$(SED_DIR)/$(SED_BINARY): $(SED_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(SED_DIR)

$(TARGET_DIR)/$(SED_TARGET_BINARY): $(SED_DIR)/$(SED_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SED_DIR) install
	mv $(TARGET_DIR)/usr/bin/sed $(TARGET_DIR)/bin/
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

sed: uclibc $(TARGET_DIR)/$(SED_TARGET_BINARY)

sed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SED_DIR) uninstall
	-sed -C $(SED_DIR) clean

sed-dirclean:
	rm -rf $(SED_DIR)

