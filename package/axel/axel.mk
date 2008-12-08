#############################################################
#
# axel
#
#############################################################
AXEL_VERSION:=1.1
AXEL_SOURCE:=axel-$(AXEL_VERSION).tar.gz
AXEL_SITE:=http://alioth.debian.org/frs/download.php/2287
AXEL_CAT:=$(ZCAT)
AXEL_DIR:=$(BUILD_DIR)/axel-$(AXEL_VERSION)
AXEL_BINARY:=axel
AXEL_TARGET_BINARY:=usr/bin/axel

$(DL_DIR)/$(AXEL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(AXEL_SITE)/$(AXEL_SOURCE)

axel-source: $(DL_DIR)/$(AXEL_SOURCE)

$(AXEL_DIR)/.unpacked: $(DL_DIR)/$(AXEL_SOURCE)
	$(AXEL_CAT) $(DL_DIR)/$(AXEL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	#toolchain/patch-kernel.sh $(AXEL_DIR) package/axel axel\*.patch
	touch $@

$(AXEL_DIR)/Makefile.settings: $(AXEL_DIR)/.unpacked
	(cd $(AXEL_DIR); \
		./configure --i18n=0 --prefix=/usr \
	)
	touch $@

$(AXEL_DIR)/$(AXEL_BINARY): $(AXEL_DIR)/Makefile.settings
	$(MAKE) CC="$(TARGET_CC)" STRIP="$(TARGET_STRIP)" -C $(AXEL_DIR)

$(TARGET_DIR)/$(AXEL_TARGET_BINARY): $(AXEL_DIR)/$(AXEL_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(AXEL_DIR) install-bin
ifeq ($(BR2_HAVE_MANPAGES),y)
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(AXEL_DIR) install-man
endif

axel: uclibc $(TARGET_DIR)/$(AXEL_TARGET_BINARY)

axel-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(AXEL_DIR) uninstall
	-$(MAKE) -C $(AXEL_DIR) clean

axel-dirclean:
	rm -rf $(AXEL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_AXEL),y)
TARGETS+=axel
endif
