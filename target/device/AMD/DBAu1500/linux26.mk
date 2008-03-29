#############################################################
#
# Linux kernel 2.6 target
#
#############################################################
ifneq ($(filter $(TARGETS),linux26),)


# Version of Linux to download and then apply patches to
DOWNLOAD_LINUX26_VERSION=2.6.19.1
# Version of Linux after applying any patches
LINUX26_VERSION=2.6.19.1



LINUX26_SOURCE=linux-$(DOWNLOAD_LINUX26_VERSION).tar.bz2
LINUX26_SITE=$(BR2_KERNEL_MIRROR)/linux/kernel/v2.6

LINUX26_FORMAT=vmlinux
LINUX26_BINLOC=$(LINUX26_FORMAT)

# Linux kernel configuration file
#LINUX26_KCONFIG=$(ALCHEMY_DBAU1500_PATH)/linux26.config
LINUX26_KCONFIG=$(BOARD_PATH)/linux26.config

# File name for the Linux kernel binary
LINUX26_KERNEL=linux-kernel-$(LINUX26_VERSION)-$(KERNEL_ARCH).srec

# Version of Linux AFTER patches
LINUX26_DIR=$(BUILD_DIR)/linux-$(LINUX26_VERSION)

# kernel patches
# This is default anyway
# LINUX26_PATCH_DIR=$(BOARD_PATH)/kernel-patches/

LINUX26_MAKE_FLAGS = $(TARGET_CONFIGURE_OPTS) ARCH=$(KERNEL_ARCH) \
	PATH=$(TARGET_PATH) INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE=$(KERNEL_CROSS)




$(DL_DIR)/$(LINUX26_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LINUX26_SITE)/$(LINUX26_SOURCE)

$(LINUX26_DIR)/.unpacked: $(DL_DIR)/$(LINUX26_SOURCE)
	rm -rf $(LINUX26_DIR)
	$(BZCAT) $(DL_DIR)/$(LINUX26_SOURCE) | tar -C $(BUILD_DIR) -xvf -
ifneq ($(DOWNLOAD_LINUX26_VERSION),$(LINUX26_VERSION))
	# Rename the dir from the downloaded version to the AFTER patch version
	mv -f $(BUILD_DIR)/linux-$(DOWNLOAD_LINUX26_VERSION) $(BUILD_DIR)/linux-$(LINUX26_VERSION)
endif
	touch $(LINUX26_DIR)/.unpacked

$(LINUX26_KCONFIG):
	@if [ ! -f "$(LINUX26_KCONFIG)" ]; then \
		echo ""; \
		echo "You should create a .config for your kernel"; \
		echo "and install it as $(LINUX26_KCONFIG)"; \
		echo ""; \
		sleep 5; \
	fi

$(LINUX26_DIR)/.patched: $(LINUX26_DIR)/.unpacked
	#toolchain/patch-kernel.sh $(LINUX26_DIR) $(LINUX26_PATCH_DIR)
	touch $(LINUX26_DIR)/.patched

$(LINUX26_DIR)/.configured: $(LINUX26_DIR)/.patched $(LINUX26_KCONFIG)
	-cp $(LINUX26_KCONFIG) $(LINUX26_DIR)/.config
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) oldconfig
	touch $(LINUX26_DIR)/.configured

linux26-menuconfig: $(LINUX26_DIR)/.patched
	[ -f $(LINUX26_DIR)/.config ] || cp $(LINUX26_KCONFIG) $(LINUX26_DIR)/.config
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) menuconfig
	-[ -f $(LINUX26_DIR)/.config ] && touch $(LINUX26_DIR)/.configured

$(LINUX26_DIR)/.depend_done: $(LINUX26_DIR)/.configured
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) prepare
	touch $(LINUX26_DIR)/.depend_done

$(LINUX26_KERNEL): $(LINUX26_DIR)/.depend_done
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) $(LINUX26_FORMAT) bzImage
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) modules
	$(KERNEL_CROSS)objcopy -O srec $(LINUX26_DIR)/$(LINUX26_BINLOC) $(LINUX26_KERNEL)
	touch -c $(LINUX26_KERNEL)

$(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/modules.dep: $(LINUX26_KERNEL)
	rm -rf $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)
	rm -f $(TARGET_DIR)/sbin/cardmgr
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) \
		DEPMOD=$(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-depmod26 \
		INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	rm -f $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/build
	touch -c $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/modules.dep

linux26: cross-depmod26 $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/modules.dep

linux26-source: $(DL_DIR)/$(LINUX26_SOURCE)

# This has been renamed so we do _NOT_ by default run this on 'make clean'
linux26clean:
	rm -f $(LINUX26_KERNEL)
	-$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX26_DIR) clean

linux26-dirclean:
	rm -rf $(LINUX26_DIR)

endif
