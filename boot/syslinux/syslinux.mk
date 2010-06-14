#############################################################
#
# syslinux to make target msdos/iso9660 filesystems bootable
#
#############################################################

SYSLINUX_VERSION:=3.85
SYSLINUX_DIR=$(BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)
SYSLINUX_SOURCE=syslinux-$(SYSLINUX_VERSION).tar.bz2
SYSLINUX_CAT:=$(BZCAT)
SYSLINUX_SITE=$(BR2_KERNEL_MIRROR)/linux/utils/boot/syslinux/3.xx/

$(DL_DIR)/$(SYSLINUX_SOURCE):
	 $(call DOWNLOAD,$(SYSLINUX_SITE),$(SYSLINUX_SOURCE))

syslinux-source: $(DL_DIR)/$(SYSLINUX_SOURCE)

$(SYSLINUX_DIR)/.unpacked: $(DL_DIR)/$(SYSLINUX_SOURCE) $(SYSLINUX_PATCH)
	mkdir -p $(@D)
	$(SYSLINUX_CAT) $(DL_DIR)/$(SYSLINUX_SOURCE) | tar $(TAR_STRIP_COMPONENTS)=1 -C $(@D) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(@D) boot/syslinux/ \*.patch
	touch -c $@

$(SYSLINUX_DIR)/.compiled: $(SYSLINUX_DIR)/.unpacked
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(HOSTCC)" AR="$(HOSTAR)" -C $(SYSLINUX_DIR)
	touch -c $@

$(BINARIES_DIR)/isolinux.bin: $(SYSLINUX_DIR)/.compiled
	cp -a $(SYSLINUX_DIR)/core/isolinux.bin $@

$(BINARIES_DIR)/pxelinux.bin: $(SYSLINUX_DIR)/.compiled
	cp -a $(SYSLINUX_DIR)/core/pxelinux.bin $@

syslinux: host-nasm $(BINARIES_DIR)/isolinux.bin
pxelinux: host-nasm $(BINARIES_DIR)/pxelinux.bin

pxelinux-clean syslinux-clean:
	rm -f $(BINARIES_DIR)/isolinux.bin $(BINARIES_DIR)/pxelinux.bin
	-$(MAKE) -C $(SYSLINUX_DIR) clean

pxelinux-dirclean syslinux-dirclean:
	rm -rf $(SYSLINUX_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_SYSLINUX),y)
TARGETS+=syslinux
endif
ifeq ($(BR2_TARGET_PXELINUX),y)
TARGETS+=pxelinux
endif
