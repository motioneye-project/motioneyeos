#############################################################
#
# findutils
#
#############################################################
FINDUTILS_SOURCE:=findutils_4.1.7.orig.tar.gz
FINDUTILS_SITE:=http://ftp.debian.org/debian/pool/main/f/findutils
FINDUTILS_CAT:=zcat
FINDUTILS_DIR:=$(BUILD_DIR)/findutils-4.1.7.orig
FINDUTILS_BINARY:=find/find
FINDUTILS_TARGET_BINARY:=usr/bin/find

$(DL_DIR)/$(FINDUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FINDUTILS_SITE)/$(FINDUTILS_SOURCE)

findutils-source: $(DL_DIR)/$(FINDUTILS_SOURCE)

$(FINDUTILS_DIR)/.unpacked: $(DL_DIR)/$(FINDUTILS_SOURCE)
	$(FINDUTILS_CAT) $(DL_DIR)/$(FINDUTILS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	(cd $(FINDUTILS_DIR); perl -i -p -e "s,# define mbstate_t int,# define mbstate_t int\n\
		# define wchar_t char,;" $(FINDUTILS_DIR)/lib/quotearg.c)
	touch $(FINDUTILS_DIR)/.unpacked

$(FINDUTILS_DIR)/.configured: $(FINDUTILS_DIR)/.unpacked
	(cd $(FINDUTILS_DIR); rm -f config.cache; CC=$(TARGET_CC1) \
	    CFLAGS=-D_POSIX_SOURCE ./configure --prefix=/usr --disable-nls \
	    --mandir=/junk --infodir=/junk --localstatedir=/var/lib/locate \
	    --libexecdir='$${prefix}/lib/locate' \
	);
	touch  $(FINDUTILS_DIR)/.configured

$(FINDUTILS_DIR)/$(FINDUTILS_BINARY): $(FINDUTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(FINDUTILS_DIR)

$(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY): $(FINDUTILS_DIR)/$(FINDUTILS_BINARY)
	$(MAKE) prefix=$(TARGET_DIR)/usr exec_prefix=$(TARGET_DIR)/usr \
	 bindir=$(TARGET_DIR)/usr/bin sbindir=$(TARGET_DIR)/usr/sbin \
	 sysconfdir=$(TARGET_DIR)/usr/etc datadir=$(TARGET_DIR)/usr/share \
	 includedir=$(TARGET_DIR)/usr/include libdir=$(TARGET_DIR)/usr/lib \
	 localstatedir=$(TARGET_DIR)/var mandir=$(TARGET_DIR)/man \
	 infodir=$(TARGET_DIR)/info CC=$(TARGET_CC1) -C $(FINDUTILS_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/junk

findutils: uclibc $(TARGET_DIR)/$(FINDUTILS_TARGET_BINARY)

findutils-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(FINDUTILS_DIR) uninstall
	-make -C $(FINDUTILS_DIR) clean

findutils-dirclean:
	rm -rf $(FINDUTILS_DIR)

