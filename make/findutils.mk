#############################################################
#
# findutils
#
#############################################################
FINDUTILS_SOURCE:=findutils_4.1.7.orig.tar.gz
FINDUTILS_SITE:=http://ftp.debian.org/debian/pool/main/f/findutils
FINDUTILS_CAT:=zcat
FINDUTILS_DIR:=$(BUILD_DIR)/findutils-4.1.7
FINDUTILS_BINARY:=find/find
FINDUTILS_TARGET_BINARY:=usr/bin/find

$(DL_DIR)/$(FINDUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FINDUTILS_SITE)/$(FINDUTILS_SOURCE)

findutils-source: $(DL_DIR)/$(FINDUTILS_SOURCE)

$(FINDUTILS_DIR)/.unpacked: $(DL_DIR)/$(FINDUTILS_SOURCE)
	$(FINDUTILS_CAT) $(DL_DIR)/$(FINDUTILS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv $(FINDUTILS_DIR).orig $(FINDUTILS_DIR)
	(cd $(FINDUTILS_DIR); perl -i -p -e "s,# define mbstate_t int,# define mbstate_t int\n\
		# define wchar_t char,;" $(FINDUTILS_DIR)/lib/quotearg.c)
	touch $(FINDUTILS_DIR)/.unpacked

$(FINDUTILS_DIR)/.configured: $(FINDUTILS_DIR)/.unpacked
	(cd $(FINDUTILS_DIR); rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var/lib \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-nls \
	);
	touch  $(FINDUTILS_DIR)/.configured

$(FINDUTILS_DIR)/$(FINDUTILS_BINARY): $(FINDUTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(FINDUTILS_DIR)

$(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY): $(FINDUTILS_DIR)/$(FINDUTILS_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(FINDUTILS_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/junk

findutils: uclibc $(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY)

findutils-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(FINDUTILS_DIR) uninstall
	-$(MAKE) -C $(FINDUTILS_DIR) clean

findutils-dirclean:
	rm -rf $(FINDUTILS_DIR)

