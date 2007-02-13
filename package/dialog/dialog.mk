#############################################################
#
# dialog
#
#############################################################
###testing: DIALOG_VERSION:=1.0-20050116-1
DIALOG_VERSION:=1.0-20060221
DIALOG_SOURCE:=dialog_$(DIALOG_VERSION).orig.tar.gz
DIALOG_SITE:=http://ftp.debian.org/debian/pool/main/d/dialog
DIALOG_DIR:=$(BUILD_DIR)/dialog-$(DIALOG_VERSION)
# http://ftp.debian.org/debian/pool/main/d/dialog/dialog_1.0-20050306-1.diff.gz
DIALOG_PATCH1:=dialog_$(DIALOG_VERSION)-3.diff.gz
DIALOG_PATCH1_URL:=$(DIALOG_SITE)
DIALOG_BINARY:=dialog
DIALOG_TARGET_BINARY:=usr/bin/dialog

$(DL_DIR)/$(DIALOG_SOURCE):
	$(WGET) -P $(DL_DIR) $(DIALOG_SITE)/$(DIALOG_SOURCE)

$(DL_DIR)/$(DIALOG_PATCH1):
	$(WGET) -P $(DL_DIR) $(DIALOG_PATCH1_URL)/$(DIALOG_PATCH1)

$(DIALOG_DIR)/.source: $(DL_DIR)/$(DIALOG_SOURCE) $(DL_DIR)/$(DIALOG_PATCH1)
	$(ZCAT) $(DL_DIR)/$(DIALOG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(ZCAT) $(DL_DIR)/$(DIALOG_PATCH1) | patch -p1 -d $(DIALOG_DIR)
	touch $@

$(DIALOG_DIR)/.configured: $(DIALOG_DIR)/.source
	(cd $(DIALOG_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	);
	touch $@

$(DIALOG_DIR)/$(DIALOG_BINARY): $(DIALOG_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(DIALOG_DIR)

$(TARGET_DIR)/$(DIALOG_TARGET_BINARY): $(DIALOG_DIR)/$(DIALOG_BINARY)
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(DIALOG_DIR) install
	rm -Rf $(TARGET_DIR)/usr/man

dialog: uclibc ncurses $(TARGET_DIR)/$(DIALOG_TARGET_BINARY)

dialog-source: $(DL_DIR)/$(DIALOG_SOURCE)

dialog-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(DIALOG_DIR) uninstall
	-$(MAKE) -C $(DIALOG_DIR) clean

dialog-dirclean:
	rm -rf $(DIALOG_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DIALOG)),y)
TARGETS+=dialog
endif
