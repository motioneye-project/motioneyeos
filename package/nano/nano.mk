#############################################################
#
# nano
#
#############################################################
NANO_VER:=1.3.10
NANO_SOURCE:=nano-$(NANO_VER).tar.gz
NANO_SITE:=http://www.nano-editor.org/dist/v1.3/
NANO_DIR:=$(BUILD_DIR)/nano-$(NANO_VER)
NANO_CAT:=zcat
NANO_BINARY:=src/nano
NANO_TARGET_BINARY:=bin/nano

$(DL_DIR)/$(NANO_SOURCE):
	$(WGET) -P $(DL_DIR) $(NANO_SITE)/$(NANO_SOURCE)

$(NANO_DIR)/.unpacked: $(DL_DIR)/$(NANO_SOURCE)
	$(NANO_CAT) $(DL_DIR)/$(NANO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(NANO_DIR)/.unpacked

$(NANO_DIR)/.configured: $(NANO_DIR)/.unpacked
	(cd $(NANO_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) CC_FOR_BUILD="$(HOSTCC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_header_regex_h=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--enable-tiny \
	);
	touch $(NANO_DIR)/.configured

$(NANO_DIR)/$(NANO_BINARY): $(NANO_DIR)/.configured
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(NANO_DIR)

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
