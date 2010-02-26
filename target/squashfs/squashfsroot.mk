#############################################################
#
# mksquashfs to build to target squashfs filesystems
#
#############################################################
SQUASHFS_VERSION:=$(call qstrip,$(BR2_TARGET_ROOTFS_SQUASHFS_VERSION))
SQUASHFS_DIR:=$(BUILD_DIR)/squashfs$(SQUASHFS_VERSION)
SQUASHFS_SOURCE:=squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs
SQUASHFS_CAT:=$(ZCAT)

$(DL_DIR)/$(SQUASHFS_SOURCE):
	 $(call DOWNLOAD,$(SQUASHFS_SITE),$(SQUASHFS_SOURCE))

$(SQUASHFS_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS_SOURCE) #$(SQUASHFS_PATCH)
	$(SQUASHFS_CAT) $(DL_DIR)/$(SQUASHFS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(SQUASHFS_DIR) target/squashfs/ squashfs-$(SQUASHFS_VERSION)-\*.patch
	touch $@

$(SQUASHFS_DIR)/squashfs-tools/mksquashfs: $(SQUASHFS_DIR)/.unpacked
	$(MAKE) CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" -C $(SQUASHFS_DIR)/squashfs-tools

squashfs: host-zlib $(SQUASHFS_DIR)/squashfs-tools/mksquashfs

squashfs-source: $(DL_DIR)/$(SQUASHFS_SOURCE)

squashfs-clean:
	-$(MAKE) -C $(SQUASHFS_DIR)/squashfs-tools clean

squashfs-dirclean:
	rm -rf $(SQUASHFS_DIR)

#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS_3),y)
# 4.x is always little endian
ifeq ($(BR2_ENDIAN),"BIG")
SQUASHFS_ENDIANNESS=-be
else
SQUASHFS_ENDIANNESS=-le
endif
endif

SQUASHFS_TARGET:=$(IMAGE).squashfs

squashfsroot: host-fakeroot makedevs squashfs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
endif
	# Use fakeroot so mksquashfs believes the previous fakery
	echo "$(SQUASHFS_DIR)/squashfs-tools/mksquashfs " \
		    "$(TARGET_DIR) $(SQUASHFS_TARGET) " \
		    "-noappend $(SQUASHFS_ENDIANNESS)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	chmod 0644 $(SQUASHFS_TARGET)
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))

squashfsroot-source: squashfs-source

squashfsroot-clean:
	-$(MAKE) -C $(SQUASHFS_DIR) clean

squashfsroot-dirclean:
	rm -rf $(SQUASHFS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS),y)
TARGETS+=squashfsroot
endif
