#############################################################
#
# gzip
#
#############################################################
GZIP_VERSION:=1.3.5
GZIP_SOURCE:=gzip-$(GZIP_VERSION).tar.gz
#GZIP_SITE:=ftp://alpha.gnu.org/gnu/gzip
GZIP_SITE:=http://mirrors.ircam.fr/pub/gnu/alpha/gnu/gzip
GZIP_DIR:=$(BUILD_DIR)/gzip-$(GZIP_VERSION)
GZIP_CAT:=$(ZCAT)
GZIP_BINARY:=$(GZIP_DIR)/gzip
GZIP_TARGET_BINARY:=$(TARGET_DIR)/bin/zmore

$(DL_DIR)/$(GZIP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GZIP_SITE)/$(GZIP_SOURCE)

gzip-source: $(DL_DIR)/$(GZIP_SOURCE)

$(GZIP_DIR)/.unpacked: $(DL_DIR)/$(GZIP_SOURCE)
	$(GZIP_CAT) $(DL_DIR)/$(GZIP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(GZIP_DIR)/.unpacked

$(GZIP_DIR)/.configured: $(GZIP_DIR)/.unpacked
	(cd $(GZIP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/ \
		--bindir=/bin \
		--sbindir=/bin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share/misc \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $(GZIP_DIR)/.configured

$(GZIP_BINARY): $(GZIP_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GZIP_DIR)

$(GZIP_TARGET_BINARY): $(GZIP_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GZIP_DIR) install
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	(cd $(TARGET_DIR)/bin; \
	$(HOSTLN) -snf gzip gunzip; \
	$(HOSTLN) -snf gzip zcat; \
	$(HOSTLN) -snf zdiff zcmp; \
	$(HOSTLN) -snf zgrep zegrep; \
	$(HOSTLN) -snf zgrep zfgrep;)

gzip: uclibc $(GZIP_TARGET_BINARY)

gzip-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GZIP_DIR) uninstall
	-$(MAKE) -C $(GZIP_DIR) clean

gzip-dirclean:
	rm -rf $(GZIP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_GZIP)),y)
TARGETS+=gzip
endif
