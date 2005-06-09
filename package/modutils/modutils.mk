#############################################################
#
# modutils
#
#############################################################
MODUTILS_SOURCE=modutils-2.4.27.tar.bz2
MODUTILS_SITE=ftp://ftp.kernel.org/pub/linux/utils/kernel/modutils/v2.4/
MODUTILS_DIR=$(BUILD_DIR)/modutils-2.4.27
MODUTILS_BINARY=insmod
MODUTILS_TARGET_BINARY=$(TARGET_DIR)/sbin/$(MODUTILS_BINARY)

STRIPPROG=$(STRIP)

$(DL_DIR)/$(MODUTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(MODUTILS_SITE)/$(MODUTILS_SOURCE)

$(MODUTILS_DIR)/.source: $(DL_DIR)/$(MODUTILS_SOURCE)
	bzcat $(DL_DIR)/$(MODUTILS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(MODUTILS_DIR) \
		package/modutils \*.patch
	touch $(MODUTILS_DIR)/.source

$(MODUTILS_DIR)/.configured: $(MODUTILS_DIR)/.source
	(cd $(MODUTILS_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		INSTALL=$(MODUTILS_DIR)/install-sh \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--sysconfdir=/etc \
	);
	touch $(MODUTILS_DIR)/.configured;

$(MODUTILS_DIR)/$(MODUTILS_BINARY): $(MODUTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(MODUTILS_DIR)

$(TARGET_DIR)/$(MODUTILS_TARGET_BINARY): $(MODUTILS_DIR)/$(MODUTILS_BINARY)
	STRIPPROG='$(STRIPPROG)' \
	$(MAKE) prefix=$(TARGET_DIR) -C $(MODUTILS_DIR) install-bin
	rm -Rf $(TARGET_DIR)/usr/man

modutils: uclibc $(TARGET_DIR)/$(MODUTILS_TARGET_BINARY)

modutils-source: $(DL_DIR)/$(MODUTILS_SOURCE)

modutils-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(MODUTILS_DIR) uninstall
	-$(MAKE) -C $(MODUTILS_DIR) clean

modutils-dirclean:
	rm -rf $(MODUTILS_DIR)

#############################################################
#
## Toplevel Makefile options
#
##############################################################
ifeq ($(strip $(BR2_PACKAGE_MODUTILS)),y)
TARGETS+=modutils
endif
