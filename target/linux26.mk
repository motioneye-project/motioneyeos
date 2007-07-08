#############################################################
#
# Linux kernel 2.6 target
#
#############################################################
ifneq ($(filter $(TARGETS),linux26),)


ifeq ($(LINUX_HEADERS_VERSION),)
# Version of Linux to download and then apply patches to
# XXX: andersee, i do not understand why we need this (BF)
DOWNLOAD_LINUX26_VERSION=2.6.19.2
# Version of Linux after applying any patches
LINUX26_VERSION=2.6.19.2
else
DOWNLOAD_LINUX26_VERSION=$(LINUX_HEADERS_VERSION)
LINUX26_VERSION=$(LINUX_HEADERS_VERSION)
endif

LINUX26_SOURCE=linux-$(DOWNLOAD_LINUX26_VERSION).tar.bz2
LINUX26_BZCAT:=$(BZCAT)
LINUX26_SITE=http://ftp.kernel.org/pub/linux/kernel/v2.6

#LINUX26_FORMAT=vmlinux
#LINUX26_BINLOC=$(LINUX26_FORMAT)

# Linux kernel configuration file
# Has to be set by the target/device
# If it is not set by the target/device, then pick the one from .config
# LINUX26_KCONFIG=$(BR2_BOARD_PATH)/linux26.config
ifndef LINUX26_KCONFIG
ifneq ($(strip $(subst ",,$(BR2_PACKAGE_LINUX_KCONFIG))),)
LINUX26_KCONFIG=$(strip $(subst ",,$(BR2_PACKAGE_LINUX_KCONFIG)))
#"))
#"))
endif
endif
ifndef LINUX26_FORMAT
ifneq ($(strip $(subst ",,$(BR2_PACKAGE_LINUX_FORMAT))),)
LINUX26_FORMAT=$(strip $(subst ",,$(BR2_PACKAGE_LINUX_FORMAT)))
#"))
#"))
endif
endif

# Has to be set by the target/device
# LINUX26_FORMAT=bzImage
ifndef LINUX26_FORMAT
LINUX26_FORMAT=zImage
endif
# Has to be set by the target/device
ifndef LINUX26_BINLOC
# default:
LINUX26_BINLOC=arch/$(KERNEL_ARCH)/boot/$(LINUX26_FORMAT)
endif

# File name for the Linux kernel binary
LINUX26_KERNEL=linux-kernel-$(LINUX26_VERSION)-$(KERNEL_ARCH)

# Version of Linux AFTER patches
LINUX26_DIR=$(BUILD_DIR)/linux-$(LINUX26_VERSION)

# for packages that need it
LINUX_VERSION:=$(LINUX_VERSION)
LINUX_DIR=$(LINUX26_DIR)
LINUX_KERNEL=$(LINUX26_KERNEL)

# kernel patches
LINUX26_PATCH_DIR=$(BR2_BOARD_PATH)/kernel-patches/
__LINUX26_NO_PIC=-fPIC -fpic -DPIC
LINUX26_MAKE_FLAGS = HOSTCC="$(HOSTCC)" HOSTCFLAGS=$(HOSTCFLAGS) \
	ARCH=$(KERNEL_ARCH) \
	CFLAGS_KERNEL="$(filter-out $(__LINUX26_NO_PIC),$(TARGET_CFLAGS))" \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE=$(KERNEL_CROSS)

$(LINUX26_KCONFIG):
	@if [ ! -f "$(LINUX26_KCONFIG)" ] ; then \
		echo ""; \
		echo "You should create a .config for your kernel"; \
		echo "and install it as $(LINUX26_KCONFIG)"; \
		echo ""; \
		sleep 5; \
	fi;

ifneq ($(strip $(LINUX26_VERSION)),$(strip $(LINUX_HEADERS_VERSION)))
$(DL_DIR)/$(LINUX26_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LINUX26_SITE)/$(LINUX26_SOURCE)

$(LINUX26_DIR)/.unpacked: $(DL_DIR)/$(LINUX26_SOURCE)
	rm -rf $(LINUX26_DIR)
	$(LINUX26_BZCAT) $(DL_DIR)/$(LINUX26_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(DOWNLOAD_LINUX26_VERSION),$(LINUX26_VERSION))
	# Rename the dir from the downloaded version to the AFTER patch version
	mv -f $(BUILD_DIR)/linux-$(DOWNLOAD_LINUX26_VERSION) $(LINUX26_DIR)
endif
	touch $@

$(LINUX26_DIR)/.patched: $(LINUX26_DIR)/.unpacked
	toolchain/patch-kernel.sh $(LINUX26_DIR) $(LINUX26_PATCH_DIR)
	touch $@
endif # ($(LINUX26_VERSION),$(LINUX_HEADERS_VERSION))

$(LINUX26_DIR)/.configured:  $(LINUX26_DIR)/.patched  $(LINUX26_KCONFIG) $(INITRAMFS_TARGET)
	cp -dpf $(LINUX26_KCONFIG) $(LINUX26_DIR)/.config
	$(SED) '/CONFIG_AEABI/d' $(LINUX26_DIR)/.config
ifeq ($(BR2_ARM_EABI),y)
	echo "CONFIG_AEABI=y" >> $(LINUX26_DIR)/.config
	$(SED) '/CONFIG_OABI_COMPAT/d' $(LINUX26_DIR)/.config
	echo "# CONFIG_OABI_COMPAT is not set" >> $(LINUX26_DIR)/.config
else
	echo "# CONFIG_AEABI is not set" >> $(LINUX26_DIR)/.config
endif
ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
	$(SED) '/CONFIG_INITRAMFS_SOURCE/d' $(LINUX26_DIR)/.config
	echo "CONFIG_INITRAMFS_SOURCE=\"$(INITRAMFS_TARGET)\"" >> \
		$(LINUX26_DIR)/.config
	$(SED) '/INITRAMFS_ROOT_.ID/d' $(LINUX26_DIR)/.config
	echo "INITRAMFS_ROOT_UID=\"0\"" >> $(LINUX26_DIR)/.config
	echo "INITRAMFS_ROOT_GID=\"0\"" >> $(LINUX26_DIR)/.config
endif
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) oldconfig
	touch $@

$(LINUX26_DIR)/.depend_done:  $(LINUX26_DIR)/.configured
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) prepare
	touch $@

$(LINUX26_KERNEL): $(LINUX26_DIR)/.depend_done
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) $(LINUX26_FORMAT)
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) modules
	cp -dpf $(LINUX26_DIR)/$(LINUX26_BINLOC) $(LINUX26_KERNEL)
	touch -c $@

$(TARGET_DIR)/boot/$(LINUX26_FORMAT): $(LINUX26_KERNEL)
	[ -d $(TARGET_DIR)/boot/ ] || mkdir $(TARGET_DIR)/boot
	cp -dpf $(LINUX26_DIR)/$(LINUX26_BINLOC) $(LINUX26_DIR)/System.map $(TARGET_DIR)/boot/
	touch -c $@

$(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/modules.dep: $(LINUX26_KERNEL)
	rm -rf $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)
	rm -f $(TARGET_DIR)/sbin/cardmgr
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) \
		DEPMOD=$(STAGING_DIR)/bin/$(GNU_TARGET_NAME)-depmod26 \
		INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	rm -f $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/build
	touch -c $@

linux26-menuconfig: $(LINUX26_DIR)/.patched host-sed
	[ -f $(LINUX26_DIR)/.config ] || cp $(LINUX26_KCONFIG) $(LINUX26_DIR)/.config
	$(MAKE) $(LINUX26_MAKE_FLAGS) -C $(LINUX26_DIR) menuconfig
	-[ -f $(LINUX26_DIR)/.config ] && touch $(LINUX26_DIR)/.configured

linux26: cross-depmod26 $(TARGET_DIR)/lib/modules/$(LINUX26_VERSION)/modules.dep $(TARGET_DIR)/boot/$(LINUX26_FORMAT)

linux26-source: $(DL_DIR)/$(LINUX26_SOURCE)

# This has been renamed so we do _NOT_ by default run this on 'make clean'
linux26clean:
	rm -f $(LINUX26_KERNEL) $(LINUX26_DIR)/.configured
	-$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX26_DIR) clean

linux26-dirclean:
	rm -rf $(LINUX26_DIR)

endif
