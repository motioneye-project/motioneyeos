#############################################################
#
# slang
#
#############################################################
SLANG_SOURCE=minislang.tar.gz
SLANG_SITE:=ftp://busybox.net/
SLANG_DIR=$(BUILD_DIR)/minislang
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
SLANG_CFLAGS="-Os -g -fPIC -D_FILE_OFFSET_BITS=64 -D__USE_FILE_OFFSET64"
else
SLANG_CFLAGS="-Os -g -fPIC"
endif

$(DL_DIR)/$(SLANG_SOURCE):
	$(WGET) -P $(DL_DIR) $(SLANG_SITE)/$(SLANG_SOURCE)

$(SLANG_DIR): $(DL_DIR)/$(SLANG_SOURCE)
	zcat $(DL_DIR)/$(SLANG_SOURCE) | tar -C $(BUILD_DIR) -xvf -

$(SLANG_DIR)/libslang.so: $(SLANG_DIR)
	$(MAKE) CFLAGS=$(SLANG_CFLAGS) CC=$(TARGET_CC1) -C $(SLANG_DIR)
	touch -c $(SLANG_DIR)/libslang.so;

$(STAGING_DIR)/lib/libslang.so.1: $(SLANG_DIR)/libslang.so
	cp -a $(SLANG_DIR)/libslang.a $(STAGING_DIR)/lib;
	cp -a $(SLANG_DIR)/libslang.so $(STAGING_DIR)/lib;
	cp -a $(SLANG_DIR)/slang.h $(STAGING_DIR)/include;
	(cd $(STAGING_DIR)/lib; ln -fs libslang.so libslang.so.1);
	touch -c $(STAGING_DIR)/lib/libslang.so.1

$(TARGET_DIR)/lib/libslang.so.1: $(STAGING_DIR)/lib/libslang.so.1
	cp -a $(STAGING_DIR)/lib/libslang.so* $(TARGET_DIR)/lib;
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libslang.so*
	touch -c $(TARGET_DIR)/lib/libslang.so.1

slang: uclibc $(TARGET_DIR)/lib/libslang.so.1

slang-source: $(DL_DIR)/$(SLANG_SOURCE)

slang-clean:
	rm -f $(TARGET_DIR)/lib/libslang.so*
	-make -C $(SLANG_DIR) clean

slang-dirclean:
	rm -rf $(SLANG_DIR)


