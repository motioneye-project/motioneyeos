ifeq ($(ARCH),i386)
#############################################################
#
# syslinux to make target msdos/iso9660 filesystems bootable
#
#############################################################

SYSLINUX_DIR=$(BUILD_DIR)/syslinux-3.09
SYSLINUX_SOURCE=syslinux-3.09.tar.bz2
SYSLINUX_SITE=http://www.kernel.org/pub/linux/utils/boot/syslinux/

$(DL_DIR)/$(SYSLINUX_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SYSLINUX_SITE)/$(SYSLINUX_SOURCE)

$(SYSLINUX_DIR)/Makefile: $(DL_DIR)/$(SYSLINUX_SOURCE) $(SYSLINUX_PATCH)
	bzcat $(DL_DIR)/$(SYSLINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
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
