#############################################################
#
# gawk
#
#############################################################
GAWK_SOURCE:=gawk-3.1.1.tar.gz
GAWK_SITE:=ftp://ftp.gnu.org/gnu/gawk
GAWK_CAT:=zcat
GAWK_DIR:=$(BUILD_DIR)/gawk-3.1.1
GAWK_BINARY:=gawk
GAWK_TARGET_BINARY:=usr/bin/gawk

$(DL_DIR)/$(GAWK_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GAWK_SITE)/$(GAWK_SOURCE)

gawk-source: $(DL_DIR)/$(GAWK_SOURCE)

$(GAWK_DIR)/.unpacked: $(DL_DIR)/$(GAWK_SOURCE)
	$(GAWK_CAT) $(DL_DIR)/$(GAWK_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(GAWK_DIR)/.unpacked

$(GAWK_DIR)/.configured: $(GAWK_DIR)/.unpacked
	(cd $(GAWK_DIR); rm -rf config.cache; \
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
	);
	touch  $(GAWK_DIR)/.configured

$(GAWK_DIR)/$(GAWK_BINARY): $(GAWK_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GAWK_DIR)

$(TARGET_DIR)/$(GAWK_TARGET_BINARY): $(GAWK_DIR)/$(GAWK_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GAWK_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

gawk: uclibc $(TARGET_DIR)/$(GAWK_TARGET_BINARY)

gawk-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GAWK_DIR) uninstall
	-$(MAKE) -C $(GAWK_DIR) clean

gawk-dirclean:
	rm -rf $(GAWK_DIR)

