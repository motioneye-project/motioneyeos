#############################################################
#
# Build the ext2 root filesystem image
#
#############################################################

EXT2_OPTS :=

ifeq ($(BR2_TARGET_ROOTFS_EXT2_SQUASH),y)
EXT2_OPTS += -U
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
EXT2_OPTS += -b $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_INODES)),0)
EXT2_OPTS += -N $(BR2_TARGET_ROOTFS_EXT2_INODES)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),)
EXT2_OPTS += -m $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)
endif

EXT2_BASE := $(call qstrip,$(BR2_TARGET_ROOTFS_EXT2_OUTPUT))

EXT2_ROOTFS_COMPRESSOR:=
EXT2_ROOTFS_COMPRESSOR_EXT:=
EXT2_ROOTFS_COMPRESSOR_PREREQ:=
ifeq ($(BR2_TARGET_ROOTFS_EXT2_GZIP),y)
EXT2_ROOTFS_COMPRESSOR:=gzip -9 -c
EXT2_ROOTFS_COMPRESSOR_EXT:=gz
endif
ifeq ($(BR2_TARGET_ROOTFS_EXT2_BZIP2),y)
EXT2_ROOTFS_COMPRESSOR:=bzip2 -9 -c
EXT2_ROOTFS_COMPRESSOR_EXT:=bz2
endif
ifeq ($(BR2_TARGET_ROOTFS_EXT2_LZMA),y)
EXT2_ROOTFS_COMPRESSOR:=$(LZMA) -9 -c
EXT2_ROOTFS_COMPRESSOR_EXT:=lzma
EXT2_ROOTFS_COMPRESSOR_PREREQ:=host-lzma
endif

ifneq ($(EXT2_ROOTFS_COMPRESSOR),)
EXT2_TARGET := $(EXT2_BASE).$(EXT2_ROOTFS_COMPRESSOR_EXT)
else
EXT2_TARGET := $(EXT2_BASE)
endif

$(EXT2_BASE): host-fakeroot host-genext2fs makedevs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
endif
	# Use fakeroot so genext2fs believes the previous fakery
ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
	GENEXT2_REALSIZE=`LC_ALL=C du -s -c -k $(TARGET_DIR) | grep total | sed -e "s/total//"`; \
	GENEXT2_ADDTOROOTSIZE=`if [ $$GENEXT2_REALSIZE -ge 20000 ]; then echo 16384; else echo 2400; fi`; \
	GENEXT2_SIZE=`expr $$GENEXT2_REALSIZE + $$GENEXT2_ADDTOROOTSIZE`; \
	GENEXT2_ADDTOINODESIZE=`find $(TARGET_DIR) | wc -l`; \
	GENEXT2_INODES=`expr $$GENEXT2_ADDTOINODESIZE + 400`; \
	set -x; \
	echo "$(HOST_DIR)/usr/bin/genext2fs -b $$GENEXT2_SIZE " \
		"-N $$GENEXT2_INODES -d $(TARGET_DIR) " \
		"$(EXT2_OPTS) $(EXT2_BASE)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
else
	echo "$(HOST_DIR)/usr/bin/genext2fs -d $(TARGET_DIR) " \
		"$(EXT2_OPTS) $(EXT2_BASE)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
endif
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))

ifneq ($(EXT2_ROOTFS_COMPRESSOR),)
$(EXT2_BASE).$(EXT2_ROOTFS_COMPRESSOR_EXT): $(EXT2_ROOTFS_COMPRESSOR_PREREQ) $(EXT2_BASE)
	$(EXT2_ROOTFS_COMPRESSOR) $(EXT2_BASE) > $(EXT2_TARGET)
endif

ext2root: $(EXT2_TARGET)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_EXT2),y)
TARGETS+=ext2root
endif
