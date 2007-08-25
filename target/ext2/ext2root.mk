#############################################################
#
# genext2fs to build to target ext2 filesystems
#
#############################################################
GENEXT2_VERSION=1.4
GENEXT2_DIR=$(BUILD_DIR)/genext2fs-$(GENEXT2_VERSION)
GENEXT2_SOURCE=genext2fs-$(GENEXT2_VERSION).tar.gz
GENEXT2_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/genext2fs

$(DL_DIR)/$(GENEXT2_SOURCE):
	$(WGET) -P $(DL_DIR) $(GENEXT2_SITE)/$(GENEXT2_SOURCE)

$(GENEXT2_DIR)/.unpacked: $(DL_DIR)/$(GENEXT2_SOURCE)
	$(ZCAT) $(DL_DIR)/$(GENEXT2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	toolchain/patch-kernel.sh $(GENEXT2_DIR) target/ext2/ genext2fs\*.patch
	touch $@

$(GENEXT2_DIR)/.configured: $(GENEXT2_DIR)/.unpacked
	chmod a+x $(GENEXT2_DIR)/configure
	(cd $(GENEXT2_DIR); rm -rf config.cache; \
		./configure \
		CC="$(HOSTCC)" \
		--prefix=$(STAGING_DIR) \
	)
	touch $@

$(GENEXT2_DIR)/genext2fs: $(GENEXT2_DIR)/.configured
	$(MAKE) CFLAGS="-Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE \
		-D_FILE_OFFSET_BITS=64" -C $(GENEXT2_DIR)
	touch -c $@

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
EXT2_OPTS += -N $(strip $(BR2_TARGET_ROOTFS_EXT2_INODES))
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),)
EXT2_OPTS += -m $(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS))
endif

EXT2_BASE := $(subst ",,$(BR2_TARGET_ROOTFS_EXT2_OUTPUT))
#")

EXT2_ROOTFS_COMPRESSOR:=
EXT2_ROOTFS_COMPRESSOR_EXT:=
EXT2_ROOTFS_COMPRESSOR_PREREQ:=
ifeq ($(BR2_TARGET_ROOTFS_EXT2_GZIP),y)
EXT2_ROOTFS_COMPRESSOR:=gzip -9 -c
EXT2_ROOTFS_COMPRESSOR_EXT:=gz
#EXT2_ROOTFS_COMPRESSOR_PREREQ:= gzip-host
endif
ifeq ($(BR2_TARGET_ROOTFS_EXT2_BZIP2),y)
EXT2_ROOTFS_COMPRESSOR:=bzip2 -9 -c
EXT2_ROOTFS_COMPRESSOR_EXT:=bz2
#EXT2_ROOTFS_COMPRESSOR_PREREQ:= bzip2-host
endif
ifeq ($(BR2_TARGET_ROOTFS_EXT2_LZMA),y)
EXT2_ROOTFS_COMPRESSOR:=lzma -9 -c
EXT2_ROOTFS_COMPRESSOR_EXT:=lzma
EXT2_ROOTFS_COMPRESSOR_PREREQ:= lzma-host
endif

ifneq ($(EXT2_ROOTFS_COMPRESSOR),)
EXT2_TARGET := $(EXT2_BASE).$(EXT2_ROOTFS_COMPRESSOR_EXT)
else
EXT2_TARGET := $(EXT2_BASE)
endif

$(EXT2_BASE): host-fakeroot makedevs genext2fs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true
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
	rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	touch $(PROJECT_BUILD_DIR)/.fakeroot.00000
	cat $(PROJECT_BUILD_DIR)/.fakeroot* > $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	echo "chown -R 0:0 $(TARGET_DIR)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
ifneq ($(TARGET_DEVICE_TABLE),)
	# Use fakeroot to pretend to create all needed device nodes
	echo "$(STAGING_DIR)/bin/makedevs -d $(TARGET_DEVICE_TABLE) $(TARGET_DIR)" \
		>> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
endif
	# Use fakeroot so genext2fs believes the previous fakery
ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
	GENEXT2_REALSIZE=`LC_ALL=C du -s -c -k $(TARGET_DIR) | grep total | sed -e "s/total//"`; \
	GENEXT2_ADDTOROOTSIZE=`if [ $$GENEXT2_REALSIZE -ge 20000 ]; then echo 16384; else echo 2400; fi`; \
	GENEXT2_SIZE=`expr $$GENEXT2_REALSIZE + $$GENEXT2_ADDTOROOTSIZE`; \
	GENEXT2_ADDTOINODESIZE=`find $(TARGET_DIR) | wc -l`; \
	GENEXT2_INODES=`expr $$GENEXT2_ADDTOINODESIZE + 400`; \
	set -x; \
	echo "$(GENEXT2_DIR)/genext2fs -b $$GENEXT2_SIZE " \
		"-N $$GENEXT2_INODES -d $(TARGET_DIR) " \
		"$(EXT2_OPTS) $(EXT2_BASE)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
else
	echo "$(GENEXT2_DIR)/genext2fs -d $(TARGET_DIR) " \
		"$(EXT2_OPTS) $(EXT2_BASE)" >> $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
endif
	chmod a+x $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	$(STAGING_DIR)/usr/bin/fakeroot -- $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))
	-@rm -f $(PROJECT_BUILD_DIR)/_fakeroot.$(notdir $(EXT2_TARGET))

ifneq ($(EXT2_ROOTFS_COMPRESSOR),)
$(EXT2_BASE).$(EXT2_ROOTFS_COMPRESSOR_EXT): $(EXT2_ROOTFS_COMPRESSOR_PREREQ) $(EXT2_BASE)
	$(EXT2_ROOTFS_COMPRESSOR) $(EXT2_BASE) > $(EXT2_TARGET)
endif

EXT2_COPYTO := $(strip $(subst ",,$(BR2_TARGET_ROOTFS_EXT2_COPYTO)))
# "))

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
