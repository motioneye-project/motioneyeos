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

SYSLINUX_VERSION:=3.31
SYSLINUX_DIR=$(BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_DIR2=$(TOOL_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_SOURCE=syslinux-$(SYSLINUX_VERSION).tar.bz2
SYSLINUX_CAT:=$(BZCAT)
SYSLINUX_SITE=http://www.kernel.org/pub/linux/utils/boot/syslinux
SYSLINUX_BIN=$(SYSLINUX_DIR2)/mtools/syslinux


$(DL_DIR)/$(SYSLINUX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SYSLINUX_SITE)/$(SYSLINUX_SOURCE)

$(SYSLINUX_DIR)/Makefile: $(DL_DIR)/$(SYSLINUX_SOURCE) $(SYSLINUX_PATCH)
	$(SYSLINUX_CAT) $(DL_DIR)/$(SYSLINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(SYSLINUX_DIR) target/x86/syslinux/ \*.patch
	touch -c $(SYSLINUX_DIR)/Makefile

$(SYSLINUX_DIR)/isolinux.bin: $(SYSLINUX_DIR)/Makefile
	$(MAKE) -C $(SYSLINUX_DIR)
	touch -c $(SYSLINUX_DIR)/isolinux.bin

syslinux: $(SYSLINUX_DIR)/isolinux.bin

syslinux-clean:
	-$(MAKE) -C $(SYSLINUX_DIR) clean

syslinux-dirclean:
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
