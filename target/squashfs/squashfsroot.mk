#############################################################
#
# mksquashfs to build to target squashfs filesystems
#
#############################################################
SQUASHFS_VERSION:=3.0
SQUASHFS_DIR:=$(BUILD_DIR)/squashfs$(SQUASHFS_VERSION)
SQUASHFS_SOURCE:=squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs
SQUASHFS_CAT:=zcat

$(DL_DIR)/$(SQUASHFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SQUASHFS_SITE)/$(SQUASHFS_SOURCE)

$(SQUASHFS_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS_SOURCE) #$(SQUASHFS_PATCH)
	$(SQUASHFS_CAT) $(DL_DIR)/$(SQUASHFS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(SQUASHFS_DIR) target/squashfs/ squashfs\*.patch
	touch $(SQUASHFS_DIR)/.unpacked

$(SQUASHFS_DIR)/squashfs-tools/mksquashfs: $(SQUASHFS_DIR)/.unpacked
	$(MAKE) -C $(SQUASHFS_DIR)/squashfs-tools;

squashfs: $(SQUASHFS_DIR)/squashfs-tools/mksquashfs

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
SQUASHFS_ENDIANNESS=-le
ifeq ($(strip $(BR2_armeb)),y)
SQUASHFS_ENDIANNESS=-be
endif
ifeq ($(strip $(BR2_mips)),y)
SQUASHFS_ENDIANNESS=-be
endif
ifeq ($(strip $(BR2_powerpc)),y)
SQUASHFS_ENDIANNESS=-be
endif
ifeq ($(strip $(BR2_sh3eb)),y)
SQUASHFS_ENDIANNESS=-be
endif
ifeq ($(strip $(BR2_sh4eb)),y)
SQUASHFS_ENDIANNESS=-be
endif
ifeq ($(strip $(BR2_sparc)),y)
SQUASHFS_ENDIANNESS=-be
endif

SQUASHFS_TARGET:=$(IMAGE).squashfs

squashfsroot: host-fakeroot makedevs squashfs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	echo "chown -R root:root $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	# Use fakeroot so mksquashfs believes the previous fakery
	echo "$(SQUASHFS_DIR)/squashfs-tools/mksquashfs " \
		    "$(TARGET_DIR) $(SQUASHFS_TARGET) " \
		    "-noappend $(SQUASHFS_ENDIANNESS)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	-@rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))

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
ifeq ($(strip $(BR2_TARGET_ROOTFS_SQUASHFS)),y)
TARGETS+=squashfsroot
endif
