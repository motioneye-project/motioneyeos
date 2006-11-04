#############################################################
#
# genext2fs to build to target ext2 filesystems
#
#############################################################
GENEXT2_DIR=$(BUILD_DIR)/genext2fs-1.3
GENEXT2_SOURCE=genext2fs_1.3.orig.tar.gz
GENEXT2_SITE=http://ftp.debian.org/debian/pool/main/g/genext2fs

$(DL_DIR)/$(GENEXT2_SOURCE):
	$(WGET) -P $(DL_DIR) $(GENEXT2_SITE)/$(GENEXT2_SOURCE)

$(GENEXT2_DIR)/.unpacked: $(DL_DIR)/$(GENEXT2_SOURCE)
	$(ZCAT) $(DL_DIR)/$(GENEXT2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv $(GENEXT2_DIR).orig $(GENEXT2_DIR)
	toolchain/patch-kernel.sh $(GENEXT2_DIR) target/ext2/ genext2fs\*.patch
	touch $(GENEXT2_DIR)/.unpacked

$(GENEXT2_DIR)/.configured: $(GENEXT2_DIR)/.unpacked
	chmod a+x $(GENEXT2_DIR)/configure
	(cd $(GENEXT2_DIR); rm -rf config.cache; \
		./configure \
		--prefix=$(STAGING_DIR) \
	);
	touch  $(GENEXT2_DIR)/.configured

$(GENEXT2_DIR)/genext2fs: $(GENEXT2_DIR)/.configured
	$(MAKE) CFLAGS="-Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE \
		-D_FILE_OFFSET_BITS=64" -C $(GENEXT2_DIR);
	touch -c $(GENEXT2_DIR)/genext2fs

genext2fs: $(GENEXT2_DIR)/genext2fs



#############################################################
#
# Build the ext2 root filesystem image
#
#############################################################

EXT2_OPTS :=

ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_SQUASH)),y)
EXT2_OPTS += -U
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
EXT2_OPTS += -b $(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS))
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_INODES)),0)
EXT2_OPTS += -i $(strip $(BR2_TARGET_ROOTFS_EXT2_INODES))
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),0)
EXT2_OPTS += -r $(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS))
endif

EXT2_BASE :=	$(subst ",,$(BR2_TARGET_ROOTFS_EXT2_OUTPUT))
# " stupid syntax highlighting does not like unmatched quote from above line

ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_GZ)),y)
EXT2_TARGET := $(EXT2_BASE).gz
else
EXT2_TARGET := $(EXT2_BASE)
endif

ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_LZMA)),y)
EXT2_TARGET := $(EXT2_BASE).lzma
endif

$(EXT2_BASE): host-fakeroot makedevs genext2fs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/share/man
	@rm -rf $(TARGET_DIR)/usr/info
	-/sbin/ldconfig -r $(TARGET_DIR) 2>/dev/null
	# Use fakeroot to pretend all target binaries are owned by root
	rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	touch $(STAGING_DIR)/.fakeroot.00000
	cat $(STAGING_DIR)/.fakeroot* > $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	echo "chown -R root:root $(TARGET_DIR)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	# Use fakeroot so genext2fs believes the previous fakery
ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
	GENEXT2_REALSIZE=`LANG=C du -l -s -c -k $(TARGET_DIR) | grep total | sed -e "s/total//"`; \
	GENEXT2_ADDTOROOTSIZE=`if [ $$GENEXT2_REALSIZE -ge 20000 ] ; then echo 16384; else echo 2400; fi`; \
	GENEXT2_SIZE=`expr $$GENEXT2_REALSIZE + $$GENEXT2_ADDTOROOTSIZE`; \
	GENEXT2_ADDTOINODESIZE=`find $(TARGET_DIR) | wc -l`; \
	GENEXT2_INODES=`expr $$GENEXT2_ADDTOINODESIZE + 400`; \
	set -x; \
	echo "$(GENEXT2_DIR)/genext2fs -b $$GENEXT2_SIZE " \
		"-i $$GENEXT2_INODES -d $(TARGET_DIR) " \
		"$(EXT2_OPTS) $(EXT2_BASE)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
else
	echo "$(GENEXT2_DIR)/genext2fs -d $(TARGET_DIR) " \
		"$(EXT2_OPTS) $(EXT2_BASE)" >> $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
endif
	chmod a+x $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	-@rm -f $(STAGING_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))

$(EXT2_BASE).gz: $(EXT2_BASE)
	@gzip --best -fv $(EXT2_BASE)

$(EXT2_BASE).lzma: lzma-host $(EXT2_BASE)
	@$(STAGING_DIR)/bin/lzma -vc $(EXT2_BASE) > $(EXT2_BASE).lzma

EXT2_COPYTO := $(strip $(subst ",,$(BR2_TARGET_ROOTFS_EXT2_COPYTO)))
# " stupid syntax highlighting does not like unmatched quote from above line

ext2root: $(EXT2_TARGET)
	@ls -l $(EXT2_TARGET)
ifneq ($(EXT2_COPYTO),)
	@cp -f $(EXT2_TARGET) $(EXT2_COPYTO)
endif

ext2root-source: $(DL_DIR)/$(GENEXT2_SOURCE)

ext2root-clean:
	-$(MAKE) -C $(GENEXT2_DIR) clean

ext2root-dirclean:
	rm -rf $(GENEXT2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2)),y)
TARGETS+=ext2root
endif
