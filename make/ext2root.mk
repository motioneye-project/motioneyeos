#############################################################
#
# genext2fs to build to target ext2 filesystems
#
#############################################################
GENEXT2_DIR=$(BUILD_DIR)/genext2fs-1.3.orig
GENEXT2_SOURCE=genext2fs_1.3.orig.tar.gz
GENEXT2_SITE=http://ftp.debian.org/debian/pool/main/g/genext2fs
GENEXT2_PATCH=$(SOURCE_DIR)/genext2fs.patch

$(DL_DIR)/$(GENEXT2_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(GENEXT2_SITE)/$(GENEXT2_SOURCE)

$(GENEXT2_DIR): $(DL_DIR)/$(GENEXT2_SOURCE) $(GENEXT2_PATCH)
	zcat $(DL_DIR)/$(GENEXT2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(GENEXT2_PATCH) | patch -p1 -d $(GENEXT2_DIR)

$(GENEXT2_DIR)/genext2fs: $(GENEXT2_DIR)
	$(MAKE) CFLAGS="-Wall -O2 -D_FILE_OFFSET_BITS=64 -D__USE_FILE_OFFSET64" -C $(GENEXT2_DIR);
	touch -c $(GENEXT2_DIR)/genext2fs

genext2fs: $(GENEXT2_DIR)/genext2fs



#############################################################
#
# Build the ext2 root filesystem image
#
# Known problems :
#  - genext2fs: couldn't allocate a block (no free space)
#  
#    Since genext2fs allocates only one group of blocks, the FS 
#    size is limited to a maximum of 8 Mb.
#
#############################################################
# FIXME -- calculate these numbers...
SIZE=4000
INODES=1000

ext2root: genext2fs #$(shell find $(TARGET_DIR) -type f)
	-@find $(TARGET_DIR)/lib -type f -name \*.so\* | xargs $(STRIP) --strip-unneeded 2>/dev/null || true;
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	$(GENEXT2_DIR)/genext2fs -i $(INODES) -b $(SIZE) -d $(TARGET_DIR) -D $(SOURCE_DIR)/device_table.txt $(IMAGE)

ext2root-source: $(DL_DIR)/$(GENEXT2_SOURCE)

ext2root-clean:
	-make -C $(GENEXT2_DIR) clean

ext2root-dirclean:
	rm -rf $(GENEXT2_DIR)

