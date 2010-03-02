#############################################################
#
# Build the ubifs root filesystem image
#
#############################################################

UBIFS_OPTS := -e $(BR2_TARGET_ROOTFS_UBIFS_LEBSIZE) -c $(BR2_TARGET_ROOTFS_UBIFS_MAXLEBCNT) -m $(BR2_TARGET_ROOTFS_UBIFS_MINIOSIZE)

UBIFS_BASE := $(call qstrip,$(BR2_TARGET_ROOTFS_UBIFS_OUTPUT))

ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_ZLIB),y)
UBIFS_OPTS += -x zlib
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_LZI),y)
UBIFS_OPTS += -x lzo
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_RT_NONE),y)
UBIFS_OPTS += -x none
endif

UBIFS_ROOTFS_COMPRESSOR:=
UBIFS_ROOTFS_COMPRESSOR_EXT:=
UBIFS_ROOTFS_COMPRESSOR_PREREQ:=
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_GZIP),y)
UBIFS_ROOTFS_COMPRESSOR:=gzip -9 -c
UBIFS_ROOTFS_COMPRESSOR_EXT:=gz
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_BZIP2),y)
UBIFS_ROOTFS_COMPRESSOR:=bzip2 -9 -c
UBIFS_ROOTFS_COMPRESSOR_EXT:=bz2
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_LZMA),y)
UBIFS_ROOTFS_COMPRESSOR:=$(LZMA) -9 -c
UBIFS_ROOTFS_COMPRESSOR_EXT:=lzma
UBIFS_ROOTFS_COMPRESSOR_PREREQ:= host-lzma
endif

ifneq ($(UBIFS_ROOTFS_COMPRESSOR),)
UBIFS_TARGET := $(UBIFS_BASE).$(UBIFS_ROOTFS_COMPRESSOR_EXT)
else
UBIFS_TARGET := $(UBIFS_BASE)
endif

$(UBIFS_BASE): host-fakeroot host-mtd makedevs
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	touch $(BUILD_DIR)/.fakeroot.00000
	cat $(BUILD_DIR)/.fakeroot* > $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(HOST_DIR)/usr/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
endif
	# Use fakeroot so mkfs.ubifs believes the previous fakery
	echo "$(HOST_DIR)/usr/sbin/mkfs.ubifs -d $(TARGET_DIR) " \
		"$(UBIFS_OPTS) -o $(UBIFS_BASE)" >> $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	chmod a+x $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	$(HOST_DIR)/usr/bin/fakeroot -- $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	-@rm -f $(BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))

ifneq ($(UBIFS_ROOTFS_COMPRESSOR),)
$(UBIFS_BASE).$(UBIFS_ROOTFS_COMPRESSOR_EXT): $(UBIFS_ROOTFS_COMPRESSOR_PREREQ) $(UBIFS_BASE)
	$(UBIFS_ROOTFS_COMPRESSOR) $(UBIFS_BASE) > $(UBIFS_TARGET)
endif

UBIFS_COPYTO := $(call qstrip,$(BR2_TARGET_ROOTFS_UBIFS_COPYTO))

ubifsroot: $(UBIFS_TARGET)
	@ls -l $(UBIFS_TARGET)
ifneq ($(UBIFS_COPYTO),)
	@cp -f $(UBIFS_TARGET) $(UBIFS_COPYTO)
endif

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_UBIFS),y)
TARGETS+=ubifsroot
endif

