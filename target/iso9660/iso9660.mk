#############################################################
#
# Build the iso96600 root filesystem image
#
#############################################################

ISO9660_TARGET_DIR=$(BUILD_DIR)/iso9660
ISO9660_TARGET:=$(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_OUTPUT))
ISO9660_BOOT_MENU:=$(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_BOOT_MENU))
ISO9660_OPTS:=

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_SQUASH),y)
ISO9660_OPTS+=-U
endif

$(ISO9660_TARGET): host-fakeroot host-cdrkit $(LINUX_KERNEL) $(EXT2_TARGET) grub
	mkdir -p $(ISO9660_TARGET_DIR)
	mkdir -p $(ISO9660_TARGET_DIR)/boot/grub
	cp $(GRUB_DIR)/stage2/stage2_eltorito $(ISO9660_TARGET_DIR)/boot/grub/
	cp $(ISO9660_BOOT_MENU) $(ISO9660_TARGET_DIR)/boot/grub/menu.lst
	cp $(LINUX_KERNEL) $(ISO9660_TARGET_DIR)/kernel
	cp $(EXT2_TARGET) $(ISO9660_TARGET_DIR)/initrd
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))
	echo "chown -R 0:0 $(ISO9660_TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))
	# Use fakeroot so mkisofs believes the previous fakery
	echo "$(HOST_DIR)/usr/bin/genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot " \
		"-boot-load-size 4 -boot-info-table -o $(ISO9660_TARGET) $(ISO9660_TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(ISO9660_TARGET))

iso9660root: $(ISO9660_TARGET)
	echo $(ISO9660_TARGET)
	@ls -l $(ISO9660_TARGET)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_ISO9660),y)
TARGETS+=iso9660root
endif
