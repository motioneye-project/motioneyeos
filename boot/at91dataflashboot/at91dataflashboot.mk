#############################################################
#
# DataFlashBoot
#
#############################################################
DATAFLASHBOOT_VERSION:=1.05
DATAFLASHBOOT_NAME:=DataflashBoot-$(DATAFLASHBOOT_VERSION)
DATAFLASHBOOT_SITE:=ftp://www.at91.com/pub/buildroot/
DATAFLASHBOOT_SOURCE:=$(DATAFLASHBOOT_NAME).tar.bz2
DATAFLASHBOOT_DIR:=$(BUILD_DIR)/at91dataflashboot-$(DATAFLASHBOOT_VERSION)
DATAFLASHBOOT_BINARY:=$(DATAFLASHBOOT_NAME).bin

$(DL_DIR)/$(DATAFLASHBOOT_SOURCE):
	 $(call DOWNLOAD,$(DATAFLASHBOOT_SITE),$(DATAFLASHBOOT_SOURCE))

$(DATAFLASHBOOT_DIR)/.unpacked: $(DL_DIR)/$(DATAFLASHBOOT_SOURCE)
	mkdir -p $(@D)
	$(BZCAT) $(DL_DIR)/$(DATAFLASHBOOT_SOURCE) | tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	touch $@

$(DATAFLASHBOOT_DIR)/.patched: $(DATAFLASHBOOT_DIR)/.unpacked
	toolchain/patch-kernel.sh $(@D) boot/at91dataflashboot \
		at91dataflashboot-$(DATAFLASHBOOT_VERSION)-\*.patch
	touch $@

$(DATAFLASHBOOT_DIR)/$(DATAFLASHBOOT_BINARY): $(DATAFLASHBOOT_DIR)/.patched
	ls $(DATAFLASHBOOT_DIR)/.unpacked
	make -C $(DATAFLASHBOOT_DIR) CROSS_COMPILE=$(TARGET_CROSS)

dataflashboot-clean:
	make -C $(DATAFLASHBOOT_DIR) clean

dataflashboot-dirclean:
	rm -rf $(DATAFLASHBOOT_DIR)

dataflash:	 $(DATAFLASHBOOT_DIR)/$(DATAFLASHBOOT_BINARY)
	cp $(DATAFLASHBOOT_DIR)/$(DATAFLASHBOOT_BINARY) $(BINARIES_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_DATAFLASHBOOT),y)
TARGETS+=dataflash
endif
