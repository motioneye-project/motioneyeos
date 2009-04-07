#############################################################
#
# mkcramfs to build to target cramfs filesystems
#
#############################################################
CRAMFS_DIR=$(BUILD_DIR)/cramfs-1.1
CRAMFS_SOURCE=cramfs-1.1.tar.gz
ifeq ($(strip $(subst ",,$(BR2_SOURCEFORGE_MIRROR))),unc)
# "))
# UNC does not seem to have cramfs
CRAMFS_SITE=http://internap.dl.sourceforge.net/sourceforge/cramfs
else
CRAMFS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/cramfs
endif

$(DL_DIR)/$(CRAMFS_SOURCE):
	 $(call DOWNLOAD,$(CRAMFS_SITE),$(CRAMFS_SOURCE))

$(CRAMFS_DIR): $(DL_DIR)/$(CRAMFS_SOURCE)
	$(ZCAT) $(DL_DIR)/$(CRAMFS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(CRAMFS_DIR) target/cramfs/ cramfs\*.patch

$(CRAMFS_DIR)/mkcramfs: $(CRAMFS_DIR)
	$(MAKE) CFLAGS="-Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" -C $(CRAMFS_DIR)
	touch -c $@

cramfs: $(CRAMFS_DIR)/mkcramfs

cramfs-source: $(DL_DIR)/$(CRAMFS_SOURCE)

cramfs-clean:
	-$(MAKE) -C $(CRAMFS_DIR) clean

cramfs-dirclean:
	rm -rf $(CRAMFS_DIR)

#############################################################
#
# Build the cramfs root filesystem image
#
#############################################################
ifeq ($(BR2_ENDIAN),"BIG")
CRAMFS_OPTS=-b
else
CRAMFS_OPTS=-l
endif

ifneq ($(TARGET_DEVICE_TABLE),)
CRAMFS_OPTS += -D $(TARGET_DEVICE_TABLE)
endif

CRAMFS_TARGET=$(IMAGE).cramfs

cramfsroot: host-fakeroot makedevs cramfs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	touch $(PROJECT_BUILD_DIR)/.fakeroot.00000
	cat $(PROJECT_BUILD_DIR)/.fakeroot* > $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
endif
	# Use fakeroot so mkcramfs believes the previous fakery
	echo "$(CRAMFS_DIR)/mkcramfs -q $(CRAMFS_OPTS) " \
		"$(TARGET_DIR) $(CRAMFS_TARGET)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	chmod a+x $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))
	-@rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(CRAMFS_TARGET))

cramfsroot-source: cramfs-source

cramfsroot-clean:
	-$(MAKE) -C $(CRAMFS_DIR) clean

cramfsroot-dirclean:
	rm -rf $(CRAMFS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_CRAMFS),y)
TARGETS+=cramfsroot
endif
