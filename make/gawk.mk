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
	(cd $(GAWK_DIR); rm -f config.cache; CC=$(TARGET_CC1) \
	    CFLAGS=-D_POSIX_SOURCE ./configure \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--sysconfdir=/etc \
		--libexecdir=/usr/lib \
		--datadir=/usr/share \
		--libdir=/usr/lib \
		--localstatedir=/var \
		--mandir=/junk \
		--infodir=/junk \
		--includedir=$(STAGING_DIR)/include \
		--oldincludedir=$(STAGING_DIR)/usr/include \
		--disable-nls \
	);
	touch  $(GAWK_DIR)/.configured

$(GAWK_DIR)/$(GAWK_BINARY): $(GAWK_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(GAWK_DIR)

$(TARGET_DIR)/$(GAWK_TARGET_BINARY): $(GAWK_DIR)/$(GAWK_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(GAWK_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/junk

gawk: uclibc $(TARGET_DIR)/$(GAWK_TARGET_BINARY)

gawk-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(GAWK_DIR) uninstall
	-make -C $(GAWK_DIR) clean

gawk-dirclean:
	rm -rf $(GAWK_DIR)

