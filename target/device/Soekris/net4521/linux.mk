#############################################################
#
# Linux kernel targets
#
# Note:  If you have any patches to apply, create the directory
# sources/kernel-patches and put your patches in there and number
# them in the order you wish to apply them...  i.e.
#
#   sources/kernel-patches/001-my-special-stuff.bz2
#   sources/kernel-patches/003-gcc-Os.bz2
#   sources/kernel-patches/004_no-warnings.bz2
#   sources/kernel-patches/030-lowlatency-mini.bz2
#   sources/kernel-patches/031-lowlatency-fixes-5.bz2
#   sources/kernel-patches/099-shutup.bz2
#   etc...
#
# these patches will all be applied by the patch-kernel.sh
# script (which will also abort the build if it finds rejects)
#  -Erik
#
#############################################################
ifneq ($(filter $(TARGETS),linux),)

# Base version of Linux kernel that we need to download
DOWNLOAD_LINUX_VERSION=2.4.29
# Version of Linux kernel AFTER applying all patches
LINUX_VERSION=2.4.29-erik


# File name for the Linux kernel binary
LINUX_KERNEL=$(BUILD_DIR)/buildroot-kernel


# Linux kernel configuration file
LINUX_KCONFIG=target/device/Soekris/net4521/linux.config

# kernel patches
LINUX_PATCH_DIR=target/device/Soekris/net4521/kernel-patches/




LINUX_FORMAT=bzImage
#LINUX_FORMAT=images/zImage.prep
LINUX_KARCH:=$(shell echo $(ARCH) | sed -e 's/i[3-9]86/i386/' \
	-e 's/mipsel/mips/' \
	-e 's/powerpc/ppc/' \
	-e 's/sh[234]/sh/' \
	)
LINUX_BINLOC=arch/$(LINUX_KARCH)/boot/$(LINUX_FORMAT)
LINUX_DIR=$(BUILD_DIR)/linux-$(LINUX_VERSION)
LINUX_SOURCE=linux-$(DOWNLOAD_LINUX_VERSION).tar.bz2
LINUX_CAT:=$(BZCAT)
LINUX_SITE=http://www.kernel.org/pub/linux/kernel/v2.4
# Used by pcmcia-cs and others
LINUX_SOURCE_DIR=$(LINUX_DIR)


$(DL_DIR)/$(LINUX_SOURCE):
	-mkdir -p $(DL_DIR)
	$(WGET) -P $(DL_DIR) $(LINUX_SITE)/$(LINUX_SOURCE)

$(LINUX_DIR)/.unpacked: $(DL_DIR)/$(LINUX_SOURCE)
	-mkdir -p $(TOOL_BUILD_DIR)
	-(cd $(TOOL_BUILD_DIR); ln -snf $(LINUX_DIR) linux)
	$(LINUX_CAT) $(DL_DIR)/$(LINUX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(DOWNLOAD_LINUX_VERSION),$(LINUX_VERSION))
	# Rename the dir from the downloaded version to the AFTER patch version
	mv -f $(BUILD_DIR)/linux-$(DOWNLOAD_LINUX_VERSION) $(BUILD_DIR)/linux-$(LINUX_VERSION)
endif
	toolchain/patch-kernel.sh $(LINUX_DIR) $(LINUX_PATCH_DIR)
	touch $(LINUX_DIR)/.unpacked

$(LINUX_KCONFIG):
	@if [ ! -f "$(LINUX_KCONFIG)" ] ; then \
		echo ""; \
		echo "You should create a .config for your kernel"; \
		echo "and install it as $(LINUX_KCONFIG)"; \
		echo ""; \
		sleep 5; \
	fi;

$(LINUX_DIR)/.configured $(BUILD_DIR)/linux/.configured:  $(LINUX_DIR)/.unpacked  $(LINUX_KCONFIG)
	$(SED) "s,^ARCH.*,ARCH=$(LINUX_KARCH),g;" $(LINUX_DIR)/Makefile
	$(SED) "s,^CROSS_COMPILE.*,CROSS_COMPILE=$(KERNEL_CROSS),g;" $(LINUX_DIR)/Makefile
	-cp $(LINUX_KCONFIG) $(LINUX_DIR)/.config
	$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX_DIR) oldconfig include/linux/version.h
	touch $(LINUX_DIR)/.configured

$(LINUX_DIR)/.depend_done:  $(LINUX_DIR)/.configured
	$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX_DIR) dep
	touch $(LINUX_DIR)/.depend_done

$(LINUX_DIR)/$(LINUX_BINLOC): $(LINUX_DIR)/.depend_done
	$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX_DIR) $(LINUX_FORMAT)
	$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX_DIR) modules

$(LINUX_KERNEL): $(LINUX_DIR)/$(LINUX_BINLOC)
	cp -fa $(LINUX_DIR)/$(LINUX_BINLOC) $(LINUX_KERNEL)
	touch -c $(LINUX_KERNEL)

$(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/modules.dep: $(LINUX_KERNEL)
	rm -rf $(TARGET_DIR)/lib/modules
	rm -f $(TARGET_DIR)/sbin/cardmgr
	$(MAKE) PATH=$(TARGET_PATH) -C $(LINUX_DIR) \
		INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
	(cd $(TARGET_DIR)/lib/modules; ln -s $(LINUX_VERSION)/kernel/drivers .)

$(STAGING_DIR)/usr/include/linux/version.h: $(LINUX_DIR)/.configured
	mkdir -p $(STAGING_DIR)/usr/include
	tar -ch -C $(LINUX_DIR)/include -f - linux | tar -xf - -C $(STAGING_DIR)/usr/include/
	tar -ch -C $(LINUX_DIR)/include -f - asm | tar -xf - -C $(STAGING_DIR)/usr/include/

linux: $(STAGING_DIR)/usr/include/linux/version.h $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/modules.dep

linux-source: $(DL_DIR)/$(LINUX_SOURCE)

# This has been renamed so we do _NOT_ by default run this on 'make clean'
linuxclean: clean
	rm -f $(LINUX_KERNEL)
	-$(MAKE) -C $(LINUX_DIR) clean

linux-dirclean:
	rm -rf $(LINUX_DIR)

endif
