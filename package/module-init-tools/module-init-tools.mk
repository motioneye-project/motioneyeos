#############################################################
#
# module-init-tools
#
#############################################################
MODULE_INIT_TOOLS_SOURCE=module-init-tools-3.2.2.tar.bz2
MODULE_INIT_TOOLS_SITE=ftp://ftp.kernel.org/pub/linux/utils/kernel/module-init-tools/
MODULE_INIT_TOOLS_DIR=$(BUILD_DIR)/module-init-tools-3.2.2
MODULE_INIT_TOOLS_BINARY=modprobe
MODULE_INIT_TOOLS_TARGET_BINARY=$(TARGET_DIR)/sbin/$(MODULE_INIT_TOOLS_BINARY)

STRIPPROG=$(STRIP)

$(DL_DIR)/$(MODULE_INIT_TOOLS_SOURCE):
	$(WGET) -P $(DL_DIR) $(MODULE_INIT_TOOLS_SITE)/$(MODULE_INIT_TOOLS_SOURCE)

$(MODULE_INIT_TOOLS_DIR)/.unpacked: $(DL_DIR)/$(MODULE_INIT_TOOLS_SOURCE)
	bzcat $(DL_DIR)/$(MODULE_INIT_TOOLS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(MODULE_INIT_TOOLS_DIR) \
		package/module-init-tools \*.patch
	touch $(MODULE_INIT_TOOLS_DIR)/.unpacked

$(MODULE_INIT_TOOLS_DIR)/.configured: $(MODULE_INIT_TOOLS_DIR)/.unpacked
	(cd $(MODULE_INIT_TOOLS_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		INSTALL=$(MODULE_INIT_TOOLS_DIR)/install-sh \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		--sysconfdir=/etc \
		--program-transform-name='' \
	);
	touch $(MODULE_INIT_TOOLS_DIR)/.configured;

$(MODULE_INIT_TOOLS_DIR)/$(MODULE_INIT_TOOLS_BINARY): $(MODULE_INIT_TOOLS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(MODULE_INIT_TOOLS_DIR)
	touch -c $(MODULE_INIT_TOOLS_DIR)/$(MODULE_INIT_TOOLS_BINARY)

ifeq ($(strip $(BR2_PACKAGE_MODUTILS)),y)
$(MODULE_INIT_TOOLS_TARGET_BINARY): \
	$(MODULE_INIT_TOOLS_DIR)/$(MODULE_INIT_TOOLS_BINARY) \
	modutils
else
$(MODULE_INIT_TOOLS_TARGET_BINARY): \
	$(MODULE_INIT_TOOLS_DIR)/$(MODULE_INIT_TOOLS_BINARY)
endif
ifeq ($(strip $(BR2_PACKAGE_MODUTILS)),y)
	$(MAKE) prefix=$(TARGET_DIR) -C $(MODULE_INIT_TOOLS_DIR) moveold
endif
	STRIPPROG='$(STRIPPROG)' \
	$(MAKE) prefix=$(TARGET_DIR) -C $(MODULE_INIT_TOOLS_DIR) install-exec
	rm -Rf $(TARGET_DIR)/usr/man
	touch -c $(MODULE_INIT_TOOLS_TARGET_BINARY)

module-init-tools: uclibc $(MODULE_INIT_TOOLS_TARGET_BINARY)

module-init-tools-source: $(DL_DIR)/$(MODULE_INIT_TOOLS_SOURCE)

module-init-tools-clean:
	$(MAKE) prefix=$(TARGET_DIR)/usr -C $(MODULE_INIT_TOOLS_DIR) uninstall
	-$(MAKE) -C $(MODULE_INIT_TOOLS_DIR) clean

module-init-tools-dirclean:
	rm -rf $(MODULE_INIT_TOOLS_DIR)

#############################################################
#
## Toplevel Makefile options
#
##############################################################
ifeq ($(strip $(BR2_PACKAGE_MODULE_INIT_TOOLS)),y)
TARGETS+=module-init-tools
endif
