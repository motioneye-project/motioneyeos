#############################################################
#
# ed
#
#############################################################
ED_VERSION:=0.6
ED_SOURCE:=ed-$(ED_VERSION).tar.bz2
ED_SITE:=http://ftp.gnu.org/gnu/ed/
ED_CAT:=$(BZCAT)
ED_DIR:=$(BUILD_DIR)/ed-$(ED_VERSION)
ED_BINARY:=ed
ED_TARGET_BINARY:=bin/ed

$(DL_DIR)/$(ED_SOURCE):
	 $(WGET) -P $(DL_DIR) $(ED_SITE)/$(ED_SOURCE)

$(ED_DIR)/.unpacked: $(DL_DIR)/$(ED_SOURCE)
	$(ED_CAT) $(DL_DIR)/$(ED_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ED_DIR) package/ed/ ed-\*.patch
	touch $@

$(ED_DIR)/.configured: $(ED_DIR)/.unpacked
	(cd $(ED_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
	);
	touch $@

$(ED_DIR)/$(ED_BINARY): $(ED_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(ED_DIR)

$(TARGET_DIR)/$(ED_TARGET_BINARY): $(ED_DIR)/$(ED_BINARY)
	cp -dpf $(ED_DIR)/$(ED_BINARY) $(TARGET_DIR)/$(ED_TARGET_BINARY)

ed: uclibc $(TARGET_DIR)/$(ED_TARGET_BINARY)

ed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(ED_DIR) uninstall
	-$(MAKE) -C $(ED_DIR) clean

ed-dirclean:
	rm -rf $(ED_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ED)),y)
TARGETS+=ed
endif
