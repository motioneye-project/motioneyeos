#############################################################
#
# bzip2
#
#############################################################
BZIP2_SOURCE=bzip2-1.0.2.tar.gz
BZIP2_SITE=ftp://sources.redhat.com/pub/bzip2/v102
BZIP2_DIR=$(BUILD_DIR)/bzip2-1.0.2

ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
BZIP2_CFLAGS="-Os -g -mpreferred-stack-boundary=2 -falign-functions=1 -falign-jumps=0 -falign-loops=0 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
else
BZIP2_CFLAGS="-Os -g -mpreferred-stack-boundary=2 -falign-functions=1 -falign-jumps=0 -falign-loops=0"
endif

$(DL_DIR)/$(BZIP2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(BZIP2_SITE)/$(BZIP2_SOURCE)

$(BZIP2_DIR)/.source: $(DL_DIR)/$(BZIP2_SOURCE)
	zcat $(DL_DIR)/$(BZIP2_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(BZIP2_DIR)/.source

$(BZIP2_DIR)/libbz2.a: $(BZIP2_DIR)/.source
	$(MAKE) CC=$(TARGET_CC1) AR=$(TARGET_CROSS)ar RANLIB=$(TARGET_CROSS)ranlib \
		CFLAGS=$(BZIP2_CFLAGS) -C $(BZIP2_DIR) libbz2.a;
	touch -c $(BZIP2_DIR)/libbz2.a

$(STAGING_DIR)/lib/libbz2.a: $(BZIP2_DIR)/libbz2.a
	cp -a $(BZIP2_DIR)/libbz2.a $(STAGING_DIR)/lib;
	cp -a $(BZIP2_DIR)/bzlib.h $(STAGING_DIR)/include;
	touch -c $(STAGING_DIR)/lib/libbz2.a

#$(TARGET_DIR)/lib/libbz2.so.1.1.4: $(STAGING_DIR)/lib/libbz2.so.1.1.4
#	cp -a $(STAGING_DIR)/lib/libbz2.so* $(TARGET_DIR)/lib;
#	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libbz2.so*
#	touch -c $(TARGET_DIR)/lib/libbz2.so.1.1.4

bzip2: uclibc $(STAGING_DIR)/lib/libbz2.a

bzip2-clean:
	-make -C $(BZIP2_DIR) clean

bzip2-dirclean:
	rm -rf $(BZIP2_DIR)

