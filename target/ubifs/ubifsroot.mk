#############################################################
#
# mkfs.ubifs to build to target ubifs filesystems
#
#############################################################
#MKFS_UBIFS_VERSION=2582f128dad78591bc3adcc87c343c690bb82e61
#MKFS_UBIFS_URL=http://git.infradead.org/users/dedekind/mkfs.ubifs.git?a=snapshot;h=$(MKFS_UBIFS_VERSION);sf=tgz
MKFS_UBIFS_VERSION=v0.4
MKFS_UBIFS_URL=http://git.infradead.org/users/dedekind/mkfs.ubifs.git?a=snapshot;h=refs/tags/mkfs.ubifs-$(MKFS_UBIFS_VERSION);sf=tgz
MKFS_UBIFS_SOURCE:=mkfs.ubifs-$(MKFS_UBIFS_VERSION).tar.gz
MKFS_UBIFS_DIR:= $(BUILD_DIR)/mkfs-ubifs-$(MKFS_UBIFS_VERSION)
MKFS_UBIFS_CAT:=$(ZCAT)
MKFS_UBIFS_NAME:=mkfs.ubifs

$(DL_DIR)/$(MKFS_UBIFS_SOURCE):
	$(WGET) -O $(DL_DIR)/$(MKFS_UBIFS_SOURCE) "$(MKFS_UBIFS_URL)"

$(MKFS_UBIFS_DIR)/.unpacked: $(DL_DIR)/$(MKFS_UBIFS_SOURCE)
	$(ZCAT) $(DL_DIR)/$(MKFS_UBIFS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv $(BUILD_DIR)/$(MKFS_UBIFS_NAME) $(MKFS_UBIFS_DIR)
	toolchain/patch-kernel.sh $(MKFS_UBIFS_DIR) target/ubifs/ mkfs-ubifs-\*.patch
	touch $@

$(MKFS_UBIFS_DIR)/mkfs.ubifs: $(MKFS_UBIFS_DIR)/.unpacked
	$(MAKE) -C $(MKFS_UBIFS_DIR)
	touch -c $@

mkfs.ubifs-dirclean:
	rm -rf $(MKFS_UBIFS_DIR)

mkfs.ubifs: $(MKFS_UBIFS_DIR)/mkfs.ubifs

#############################################################
#
# Build the ubifs root filesystem image
#
#############################################################

UBIFS_OPTS := -e $(BR2_TARGET_ROOTFS_UBIFS_LEBSIZE) -c $(BR2_TARGET_ROOTFS_UBIFS_MAXLEBCNT) -m $(BR2_TARGET_ROOTFS_UBIFS_MINIOSIZE)

UBIFS_BASE := $(subst ",,$(BR2_TARGET_ROOTFS_UBIFS_OUTPUT))
#")

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
#UBIFS_ROOTFS_COMPRESSOR_PREREQ:= gzip-host
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_BZIP2),y)
UBIFS_ROOTFS_COMPRESSOR:=bzip2 -9 -c
UBIFS_ROOTFS_COMPRESSOR_EXT:=bz2
#UBIFS_ROOTFS_COMPRESSOR_PREREQ:= bzip2-host
endif
ifeq ($(BR2_TARGET_ROOTFS_UBIFS_LZMA),y)
UBIFS_ROOTFS_COMPRESSOR:=lzma -9 -c
UBIFS_ROOTFS_COMPRESSOR_EXT:=lzma
UBIFS_ROOTFS_COMPRESSOR_PREREQ:= lzma-host
endif

ifneq ($(UBIFS_ROOTFS_COMPRESSOR),)
UBIFS_TARGET := $(UBIFS_BASE).$(UBIFS_ROOTFS_COMPRESSOR_EXT)
else
UBIFS_TARGET := $(UBIFS_BASE)
endif

$(UBIFS_BASE): host-fakeroot makedevs mkfs.ubifs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIPCMD) 2>/dev/null || true
ifneq ($(BR2_HAVE_MANPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/share/man
endif
ifneq ($(BR2_HAVE_INFOPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/info
endif
	@test -d $(TARGET_DIR)/usr/share && \
		rmdir -p --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share || \
		true
	$(if $(TARGET_LDCONFIG),test -x $(TARGET_LDCONFIG) && $(TARGET_LDCONFIG) -r $(TARGET_DIR) 2>/dev/null)
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	touch $(PROJECT_BUILD_DIR)/.fakeroot.00000
	cat $(PROJECT_BUILD_DIR)/.fakeroot* > $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
ifneq ($(BR2_TARGET_ROOTFS_UBIFS_SQUASH),)
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
endif
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
endif
	# Use fakeroot so mkfs.ubifs believes the previous fakery
	echo "$(MKFS_UBIFS_DIR)/mkfs.ubifs -d $(TARGET_DIR) " \
		"$(UBIFS_OPTS) -o $(UBIFS_BASE)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	chmod a+x $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))
	-@rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(UBIFS_TARGET))

ifneq ($(UBIFS_ROOTFS_COMPRESSOR),)
$(UBIFS_BASE).$(UBIFS_ROOTFS_COMPRESSOR_EXT): $(UBIFS_ROOTFS_COMPRESSOR_PREREQ) $(UBIFS_BASE)
	$(UBIFS_ROOTFS_COMPRESSOR) $(UBIFS_BASE) > $(UBIFS_TARGET)
endif

UBIFS_COPYTO := $(subst ",,$(BR2_TARGET_ROOTFS_UBIFS_COPYTO))
# "))

ubifsroot: $(UBIFS_TARGET)
	@ls -l $(UBIFS_TARGET)
ifneq ($(UBIFS_COPYTO),)
	@cp -f $(UBIFS_TARGET) $(UBIFS_COPYTO)
endif

ubifsroot-source: $(DL_DIR)/$(GENUBIFS_SOURCE)

ubifsroot-clean:
	-$(MAKE) -C $(MKFS_UBIFS_DIR) clean

ubifsroot-dirclean:
	rm -rf $(MKFS_UBIFS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_TARGET_ROOTFS_UBIFS),y)
TARGETS+=ubifsroot
endif

