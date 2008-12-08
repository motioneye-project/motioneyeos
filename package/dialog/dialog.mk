#############################################################
#
# dialog
#
#############################################################
DIALOG_VERSION:=1.1-20070704
DIALOG_SOURCE:=dialog-$(DIALOG_VERSION).tgz
DIALOG_SITE:=ftp://invisible-island.net/dialog
DIALOG_DIR:=$(BUILD_DIR)/dialog-$(DIALOG_VERSION)
DIALOG_BINARY:=dialog
DIALOG_TARGET_BINARY:=usr/bin/dialog

$(DL_DIR)/$(DIALOG_SOURCE):
	$(WGET) -P $(DL_DIR) $(DIALOG_SITE)/$(DIALOG_SOURCE)

$(DIALOG_DIR)/.source: $(DL_DIR)/$(DIALOG_SOURCE)
	$(ZCAT) $(DL_DIR)/$(DIALOG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(DIALOG_DIR)
	touch $@

$(DIALOG_DIR)/.configured: $(DIALOG_DIR)/.source
	(cd $(DIALOG_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc; \
	)
	touch $@

$(DIALOG_DIR)/$(DIALOG_BINARY): $(DIALOG_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(DIALOG_DIR)
	touch -c $@

$(TARGET_DIR)/$(DIALOG_TARGET_BINARY): $(DIALOG_DIR)/$(DIALOG_BINARY)
	$(MAKE) prefix=$(TARGET_DIR)/usr \
		mandir=$(TARGET_DIR)/usr/share/man \
		-C $(DIALOG_DIR) install
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -Rf $(TARGET_DIR)/usr/share/man
endif

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
ifeq ($(BR2_PACKAGE_DIALOG),y)
TARGETS+=dialog
endif
