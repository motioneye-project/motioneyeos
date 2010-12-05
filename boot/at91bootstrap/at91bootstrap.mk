#############################################################
#
# at91bootstrap
#
#############################################################
AT91BOOTSTRAP_VERSION:=1.16
AT91BOOTSTRAP_NAME:=AT91Bootstrap$(AT91BOOTSTRAP_VERSION)
AT91BOOTSTRAP_SITE:=http://www.atmel.com/dyn/resources/prod_documents/
AT91BOOTSTRAP_SOURCE:=$(AT91BOOTSTRAP_NAME).zip
AT91BOOTSTRAP_DIR:=$(BUILD_DIR)/at91bootstrap-$(AT91BOOTSTRAP_VERSION)

AT91BOOTSTRAP_BOARD:=$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_BOARD))
AT91BOOTSTRAP_MEMORY:=$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_MEMORY))
AT91BOOTSTRAP_BINARY:=$(AT91BOOTSTRAP_MEMORY)_$(AT91BOOTSTRAP_BOARD).bin
AT91BOOTSTRAP_BUILD_DIR:=$(AT91BOOTSTRAP_DIR)/board/$(AT91BOOTSTRAP_BOARD)/$(AT91BOOTSTRAP_MEMORY)
AT91BOOTSTRAP_TARGET:=$(AT91BOOTSTRAP_BUILD_DIR)/$(AT91BOOTSTRAP_BINARY)

$(DL_DIR)/$(AT91BOOTSTRAP_SOURCE):
	 $(call DOWNLOAD,$(AT91BOOTSTRAP_SITE),$(AT91BOOTSTRAP_SOURCE))

$(AT91BOOTSTRAP_DIR)/.unpacked: $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE)
	mkdir -p $(BUILD_DIR)
	unzip -d $(BUILD_DIR) $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE)
	mv $(BUILD_DIR)/Bootstrap-v$(AT91BOOTSTRAP_VERSION) $(AT91BOOTSTRAP_DIR)
	touch $@

$(AT91BOOTSTRAP_DIR)/.patched: $(AT91BOOTSTRAP_DIR)/.unpacked
	toolchain/patch-kernel.sh $(AT91BOOTSTRAP_DIR) boot/at91bootstrap/ at91bootstrap-$(AT91BOOTSTRAP_VERSION)\*.patch
	touch $@

$(AT91BOOTSTRAP_TARGET): $(AT91BOOTSTRAP_DIR)/.patched
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		-C $(AT91BOOTSTRAP_BUILD_DIR)

$(BINARIES_DIR)/$(AT91BOOTSTRAP_BINARY): $(AT91BOOTSTRAP_TARGET)
	mkdir -p $(dir $@)
	cp $^ $@

at91bootstrap: $(BINARIES_DIR)/$(AT91BOOTSTRAP_BINARY)

at91bootstrap-source: $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE)

at91bootstrap-unpacked: $(AT91BOOTSTRAP_DIR)/.unpacked

at91bootstrap-clean:
	make -C $(AT91BOOTSTRAP_BUILD_DIR) clean

at91bootstrap-dirclean:
	rm -rf $(AT91BOOTSTRAP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_AT91BOOTSTRAP),y)
TARGETS+=at91bootstrap

# we NEED a board name unless we're at make source
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(AT91BOOTSTRAP_BOARD),)
$(error No AT91Bootstrap board name set. Check your BR2_TARGET_AT91BOOTSTRAP_BOARD setting)
endif
endif

endif
