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
	zcat $(DL_DIR)/$(GENEXT2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv $(GENEXT2_DIR).orig $(GENEXT2_DIR)
	toolchain/patch-kernel.sh $(GENEXT2_DIR) target/ext2/ genext2fs*.patch
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

# How much KB we want to add to the calculated size for slack space
GENEXT2_REALSIZE=$(subst total,, $(shell LANG=C du $(TARGET_DIR) -s -c -k | grep total ))
GENEXT2_ADDTOROOTSIZE=$(shell if [ $(GENEXT2_REALSIZE) -ge 20000 ] ; then echo 16384; else echo 16; fi)
GENEXT2_SIZE=$(shell expr $(GENEXT2_REALSIZE) + $(GENEXT2_ADDTOROOTSIZE) + 200)
# We currently add about 400 device nodes, so add that into the total
GENEXT2_INODES=$(shell expr $(shell find $(TARGET_DIR) | wc -l) + 400)
#GENEXT2_SIZE=100000

ext2root: genext2fs
	#-@find $(TARGET_DIR)/lib -type f -name \*.so\* | xargs $(STRIP) --strip-unneeded 2>/dev/null || true;
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIP) 2>/dev/null || true;
	$(GENEXT2_DIR)/genext2fs -i $(GENEXT2_INODES) -b $(GENEXT2_SIZE) \
		-d $(TARGET_DIR) -q -D target/default/device_table.txt $(IMAGE).ext2

ext2root-source: $(DL_DIR)/$(GENEXT2_SOURCE)

ext2root-clean:
	-$(MAKE) -C $(GENEXT2_DIR) clean

ext2root-dirclean:
	rm -rf $(GENEXT2_DIR)

