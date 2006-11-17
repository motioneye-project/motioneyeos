#############################################################
#
# slang
#
#############################################################
SLANG_SOURCE=slang-1.4.5-mini.tar.bz2
SLANG_CAT:=$(BZCAT)
SLANG_SITE:=http://www.uclibc.org/
SLANG_DIR=$(BUILD_DIR)/slang-1.4.5-mini
ifeq ($(BR2_LARGEFILE),y)
SLANG_CFLAGS=-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
endif
SLANG_CFLAGS+=-fPIC

$(DL_DIR)/$(SLANG_SOURCE):
	$(WGET) -P $(DL_DIR) $(SLANG_SITE)/$(SLANG_SOURCE)

$(SLANG_DIR): $(DL_DIR)/$(SLANG_SOURCE)
	$(SLANG_CAT) $(DL_DIR)/$(SLANG_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -

$(SLANG_DIR)/libslang.so: $(SLANG_DIR)
	$(MAKE1) CFLAGS="-Os -g $(SLANG_CFLAGS)" CC=$(TARGET_CC) -C $(SLANG_DIR)
	touch -c $(SLANG_DIR)/libslang.so;

$(STAGING_DIR)/lib/libslang.so.1: $(SLANG_DIR)/libslang.so
	cp -a $(SLANG_DIR)/libslang.a $(STAGING_DIR)/lib;
	cp -a $(SLANG_DIR)/libslang.so $(STAGING_DIR)/lib;
	cp -a $(SLANG_DIR)/slang.h $(STAGING_DIR)/include;
	cp -a $(SLANG_DIR)/slcurses.h $(STAGING_DIR)/include;
	(cd $(STAGING_DIR)/lib; ln -fs libslang.so libslang.so.1);
	touch -c $(STAGING_DIR)/lib/libslang.so.1

$(TARGET_DIR)/lib/libslang.so.1: $(STAGING_DIR)/lib/libslang.so.1
	cp -a $(STAGING_DIR)/lib/libslang.so* $(TARGET_DIR)/lib;
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libslang.so*
	touch -c $(TARGET_DIR)/lib/libslang.so.1

slang: uclibc $(STAGING_DIR)/lib/libslang.so.1 $(TARGET_DIR)/lib/libslang.so.1

slang-source: $(DL_DIR)/$(SLANG_SOURCE)

slang-clean:
	rm -f $(TARGET_DIR)/lib/libslang.so*
	-$(MAKE) -C $(SLANG_DIR) clean

slang-dirclean:
	rm -rf $(SLANG_DIR)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SLANG)),y)
TARGETS+=slang
endif
