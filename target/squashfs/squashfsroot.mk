#############################################################
#
# mksquashfs to build to target squashfs filesystems
#
#############################################################
SQUASHFS_VERSION:=3.3
SQUASHFS_DIR:=$(BUILD_DIR)/squashfs$(SQUASHFS_VERSION)
SQUASHFS_SOURCE:=squashfs$(SQUASHFS_VERSION).tar.gz
SQUASHFS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/squashfs
SQUASHFS_CAT:=$(ZCAT)

$(DL_DIR)/$(SQUASHFS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SQUASHFS_SITE)/$(SQUASHFS_SOURCE)

$(SQUASHFS_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS_SOURCE) #$(SQUASHFS_PATCH)
	$(SQUASHFS_CAT) $(DL_DIR)/$(SQUASHFS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(SQUASHFS_DIR) target/squashfs/ squashfs\*.patch
	touch $@

$(SQUASHFS_DIR)/squashfs-tools/mksquashfs: $(SQUASHFS_DIR)/.unpacked
	$(MAKE) -C $(SQUASHFS_DIR)/squashfs-tools

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
ifeq ($(BR2_ENDIAN),"BIG")
SQUASHFS_ENDIANNESS=-be
else
SQUASHFS_ENDIANNESS=-le
endif

SQUASHFS_TARGET:=$(IMAGE).squashfs

squashfsroot: host-fakeroot makedevs squashfs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIPCMD) 2>/dev/null || true
ifneq ($(BR2_HAVE_MANPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/man
endif
ifneq ($(BR2_HAVE_INFOPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/info
endif
	$(if $(TARGET_LDCONFIG),test -x $(TARGET_LDCONFIG) && $(TARGET_LDCONFIG) -r $(TARGET_DIR) 2>/dev/null)
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	touch $(PROJECT_BUILD_DIR)/.fakeroot.00000
	cat $(PROJECT_BUILD_DIR)/.fakeroot* > $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
endif
	# Use fakeroot so mksquashfs believes the previous fakery
	echo "$(SQUASHFS_DIR)/squashfs-tools/mksquashfs " \
		    "$(TARGET_DIR) $(SQUASHFS_TARGET) " \
		    "-noappend $(SQUASHFS_ENDIANNESS)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	chmod a+x $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))
	-@rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(SQUASHFS_TARGET))

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
