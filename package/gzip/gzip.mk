#############################################################
#
# gzip
#
#############################################################
GZIP_VERSION:=1.3.12
GZIP_SOURCE:=gzip-$(GZIP_VERSION).tar.gz
GZIP_SITE:=$(BR2_GNU_MIRROR)/gzip
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
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $(GZIP_DIR)/.configured

$(GZIP_BINARY): $(GZIP_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GZIP_DIR)

$(GZIP_TARGET_BINARY): $(GZIP_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GZIP_DIR) install-strip
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif

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
ifeq ($(BR2_PACKAGE_GZIP),y)
TARGETS+=gzip
endif
