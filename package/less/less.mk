#############################################################
#
# less
#
#############################################################
LESS_VERSION:=394
LESS_SOURCE:=less-$(LESS_VERSION).tar.gz
LESS_SITE:=http://www.greenwoodsoftware.com/less
LESS_DIR:=$(BUILD_DIR)/less-$(LESS_VERSION)
LESS_BINARY:=less
LESS_TARGET_BINARY:=usr/bin/less

$(DL_DIR)/$(LESS_SOURCE):
	$(WGET) -P $(DL_DIR) $(LESS_SITE)/$(LESS_SOURCE)

$(LESS_DIR)/.source: $(DL_DIR)/$(LESS_SOURCE)
	$(ZCAT) $(DL_DIR)/$(LESS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(LESS_DIR)/.configured: $(LESS_DIR)/.source
	(cd $(LESS_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
	)
	touch $@

$(LESS_DIR)/$(LESS_BINARY): $(LESS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LESS_DIR)

$(TARGET_DIR)/$(LESS_TARGET_BINARY): $(LESS_DIR)/$(LESS_BINARY)
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LESS_DIR) install
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -Rf $(TARGET_DIR)/usr/man
endif

less: uclibc ncurses $(TARGET_DIR)/$(LESS_TARGET_BINARY)

less-source: $(DL_DIR)/$(LESS_SOURCE)

less-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(LESS_DIR) uninstall
	-$(MAKE) -C $(LESS_DIR) clean

less-dirclean:
	rm -rf $(LESS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LESS)),y)
TARGETS+=less
endif
