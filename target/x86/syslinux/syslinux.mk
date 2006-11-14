ifeq ($(ARCH),i386)
#############################################################
#
# syslinux to make target msdos/iso9660 filesystems bootable
#
#############################################################

SYSLINUX_VERSION:=3.31
SYSLINUX_DIR=$(BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_DIR2=$(TOOL_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_SOURCE=syslinux-$(SYSLINUX_VERSION).tar.bz2
SYSLINUX_SITE=http://www.kernel.org/pub/linux/utils/boot/syslinux
SYSLINUX_BIN=$(SYSLINUX_DIR2)/mtools/syslinux


$(DL_DIR)/$(SYSLINUX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SYSLINUX_SITE)/$(SYSLINUX_SOURCE)

$(SYSLINUX_DIR)/Makefile: $(DL_DIR)/$(SYSLINUX_SOURCE) $(SYSLINUX_PATCH)
	bzcat $(DL_DIR)/$(SYSLINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(SYSLINUX_DIR) target/x86/syslinux/ \*.patch
	touch -c $(SYSLINUX_DIR)/Makefile

$(SYSLINUX_DIR)/isolinux.bin: $(SYSLINUX_DIR)/Makefile
	$(MAKE) -C $(SYSLINUX_DIR)
	touch -c $(SYSLINUX_DIR)/isolinux.bin

syslinux: $(SYSLINUX_DIR)/isolinux.bin

syslinux-clean:
	-make -C $(SYSLINUX_DIR) clean

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
