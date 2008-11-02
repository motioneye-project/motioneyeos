SYSLINUX_SUPPORTED_ARCH=n
ifeq ($(ARCH),i386)
SYSLINUX_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i486)
SYSLINUX_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i586)
SYSLINUX_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),i686)
SYSLINUX_SUPPORTED_ARCH=y
endif
ifeq ($(ARCH),x86_64)
SYSLINUX_SUPPORTED_ARCH=y
endif
ifeq ($(SYSLINUX_SUPPORTED_ARCH),y)

#############################################################
#
# syslinux to make target msdos/iso9660 filesystems bootable
#
#############################################################

SYSLINUX_VERSION:=3.61
SYSLINUX_DIR=$(BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_DIR2=$(TOOL_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_SOURCE=syslinux-$(SYSLINUX_VERSION).tar.bz2
SYSLINUX_CAT:=$(BZCAT)
SYSLINUX_SITE=$(BR2_KERNEL_MIRROR)/linux/utils/boot/syslinux/Old
SYSLINUX_BIN=$(SYSLINUX_DIR2)/mtools/syslinux


$(DL_DIR)/$(SYSLINUX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SYSLINUX_SITE)/$(SYSLINUX_SOURCE)

syslinux-source: $(DL_DIR)/$(SYSLINUX_SOURCE)

$(SYSLINUX_DIR)/Makefile: $(DL_DIR)/$(SYSLINUX_SOURCE) $(SYSLINUX_PATCH)
	$(SYSLINUX_CAT) $(DL_DIR)/$(SYSLINUX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(SYSLINUX_DIR) target/x86/syslinux/ \*.patch
	touch -c $@

$(SYSLINUX_DIR)/isolinux.bin $(SYSLINUX_DIR)/pxelinux.bin: $(SYSLINUX_DIR)/Makefile
	$(MAKE) CC="$(HOSTCC)" AR="$(HOSTAR)" -C $(SYSLINUX_DIR)
	touch -c $@

syslinux: $(SYSLINUX_DIR)/isolinux.bin
pxelinux: $(SYSLINUX_DIR)/pxelinux.bin

pxelinux-clean syslinux-clean:
	rm -f $(SYSLINUX_DIR)/isolinux.bin $(SYSLINUX_DIR)/pxelinux.bin
	-$(MAKE) -C $(SYSLINUX_DIR) clean

pxelinux-dirclean syslinux-dirclean:
	rm -rf $(SYSLINUX_DIR)

endif

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_SYSLINUX)),y)
TARGETS+=syslinux
endif
ifeq ($(strip $(BR2_TARGET_PXELINUX)),y)
TARGETS+=pxelinux
endif
