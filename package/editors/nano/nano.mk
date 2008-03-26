#############################################################
#
# nano
#
#############################################################
NANO_VERSION:=1.3.12
NANO_SOURCE:=nano-$(NANO_VERSION).tar.gz
NANO_SITE:=http://www.nano-editor.org/dist/v1.3/
NANO_DIR:=$(BUILD_DIR)/nano-$(NANO_VERSION)
NANO_CAT:=$(ZCAT)
NANO_BINARY:=src/nano
NANO_TARGET_BINARY:=usr/bin/nano

$(DL_DIR)/$(NANO_SOURCE):
	$(WGET) -P $(DL_DIR) $(NANO_SITE)/$(NANO_SOURCE)

nano-source: $(DL_DIR)/$(NANO_SOURCE)

$(NANO_DIR)/.unpacked: $(DL_DIR)/$(NANO_SOURCE)
	$(NANO_CAT) $(DL_DIR)/$(NANO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(NANO_DIR)
	touch $@

$(NANO_DIR)/.configured: $(NANO_DIR)/.unpacked
	(cd $(NANO_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_header_regex_h=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--enable-tiny \
	)
	touch $@

$(NANO_DIR)/$(NANO_BINARY): $(NANO_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(NANO_DIR)

$(TARGET_DIR)/$(NANO_TARGET_BINARY): $(NANO_DIR)/$(NANO_BINARY)
	install -D $(NANO_DIR)/$(NANO_BINARY) $(TARGET_DIR)/$(NANO_TARGET_BINARY)

nano: uclibc ncurses $(TARGET_DIR)/$(NANO_TARGET_BINARY)

nano-clean:
	rm -f $(TARGET_DIR)/$(NANO_TARGET_BINARY)
	-$(MAKE) -C $(NANO_DIR) clean

nano-dirclean:
	rm -rf $(NANO_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NANO)),y)
TARGETS+=nano
endif
