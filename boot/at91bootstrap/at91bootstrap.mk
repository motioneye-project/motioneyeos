#############################################################
#
# at91bootstrap
#
#############################################################
AT91BOOTSTRAP_VERSION:=2.13
AT91BOOTSTRAP_NAME:=at91bootstrap-$(AT91BOOTSTRAP_VERSION)
AT91BOOTSTRAP_SITE:=ftp://www.at91.com/pub/buildroot/
AT91BOOTSTRAP_SOURCE:=$(AT91BOOTSTRAP_NAME).tar.bz2
AT91BOOTSTRAP_DIR:=$(BUILD_DIR)/$(AT91BOOTSTRAP_NAME)
AT91BOOTSTRAP:=$(call qstrip,$(BR2_AT91BOOTSTRAP))
AT91BOOTSTRAP_ZCAT:=$(BZCAT)

AT91BOOTSTRAP_BOARD:=$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_BOARD))
AT91BOOTSTRAP_MEMORY:=$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP_MEMORY))
AT91BOOTSTRAP_BINARY:=$(AT91BOOTSTRAP_BOARD)-$(AT91BOOTSTRAP_MEMORY)boot.bin
AT91BOOTSTRAP_TARGET:=$(AT91BOOTSTRAP_DIR)/binaries/$(AT91BOOTSTRAP_BINARY)
AT91BOOTSTRAP_JUMP_ADDR:=$(call qstrip,$(BR2_AT91BOOTSTRAP_JUMP_ADDR))
AT91BOOTSTRAP_IMG_SIZE:=$(call qstrip,$(BR2_AT91BOOTSTRAP_IMG_SIZE))

AT91_CUSTOM_FLAGS:=
ifneq ($(AT91BOOTSTRAP_JUMP_ADDR),)
AT91_CUSTOM_FLAGS+=-DJUMP_ADDR=$(AT91BOOTSTRAP_JUMP_ADDR)
endif
ifneq ($(AT91BOOTSTRAP_IMG_SIZE),)
AT91_CUSTOM_FLAGS+=-DIMG_SIZE=$(AT91BOOTSTRAP_IMG_SIZE)
endif

$(DL_DIR)/$(AT91BOOTSTRAP_SOURCE):
	 $(call DOWNLOAD,$(AT91BOOTSTRAP_SITE),$(AT91BOOTSTRAP_SOURCE))

$(AT91BOOTSTRAP_DIR)/.unpacked: $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE)
	mkdir -p $(BUILD_DIR)
	$(AT91BOOTSTRAP_ZCAT) $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(AT91BOOTSTRAP_DIR) boot/at91bootstrap/ at91bootstrap-$(AT91BOOTSTRAP_VERSION)\*.patch
	touch $(AT91BOOTSTRAP_DIR)/.unpacked

$(AT91BOOTSTRAP_DIR)/.configured: $(AT91BOOTSTRAP_DIR)/.unpacked
	$(MAKE) \
		MEMORY=$(AT91BOOTSTRAP_MEMORY) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		-C $(AT91BOOTSTRAP_DIR) \
		$(AT91BOOTSTRAP_BOARD)_defconfig
	touch $(AT91BOOTSTRAP_DIR)/.configured

$(AT91BOOTSTRAP_TARGET): $(AT91BOOTSTRAP_DIR)/.configured
	$(MAKE) \
		MEMORY=$(AT91BOOTSTRAP_MEMORY) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		AT91_CUSTOM_FLAGS="$(AT91_CUSTOM_FLAGS)" \
		-C $(AT91BOOTSTRAP_DIR)

$(AT91BOOTSTRAP_DIR)/.installed:: $(AT91BOOTSTRAP_TARGET)
	mkdir -p $(BINARIES_DIR)
	make MEMORY=$(AT91BOOTSTRAP_MEMORY) 	\
		CROSS_COMPILE=$(TARGET_CROSS) 	\
		DESTDIR=$(BINARIES_DIR) 	\
		-C $(AT91BOOTSTRAP_DIR) install
	touch $@

.PHONY: at91bootstrap at91bootstrap-source

at91bootstrap: $(AT91BOOTSTRAP_DIR)/.installed

at91bootstrap-source: $(DL_DIR)/$(AT91BOOTSTRAP_SOURCE)

at91bootstrap-unpacked: $(AT91BOOTSTRAP_DIR)/.unpacked

.PHONY: at91bootstrap-clean at91bootstrap-dirclean

at91bootstrap-clean:
	make -C $(AT91BOOTSTRAP_DIR) clean

at91bootstrap-dirclean:
	rm -rf $(AT91BOOTSTRAP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_AT91BOOTSTRAP),y)
TARGETS+=at91bootstrap

# we NEED a board name
ifeq ($(AT91BOOTSTRAP_BOARD),)
$(error No AT91Bootstrap board name set. Check your BR2_TARGET_AT91BOOTSTRAP_BOARD setting)
endif
endif
