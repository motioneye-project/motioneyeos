#############################################################
#
# zlib
#
#############################################################
ZLIB_SOURCE=zlib-1.1.4.tar.bz2
ZLIB_SITE=http://telia.dl.sourceforge.net/sourceforge/libpng
ZLIB_DIR=$(BUILD_DIR)/zlib-1.1.4
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
ZLIB_CFLAGS="-Os -g -fPIC -D_FILE_OFFSET_BITS=64 -D__USE_FILE_OFFSET64"
else
ZLIB_CFLAGS="-Os -g -fPIC"
endif

$(DL_DIR)/$(ZLIB_SOURCE):
	wget -P $(DL_DIR) $(ZLIB_SITE)/$(ZLIB_SOURCE)

$(ZLIB_DIR)/.source: $(DL_DIR)/$(ZLIB_SOURCE)
	bzcat $(DL_DIR)/$(ZLIB_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(ZLIB_DIR)/.source

$(ZLIB_DIR)/.configured: $(ZLIB_DIR)/.source
	(cd $(ZLIB_DIR); ./configure --shared --prefix=/usr --exec_prefix=$(STAGING_DIR)/usr/bin \
		--libdir=$(STAGING_DIR)/lib --includedir=$(STAGING_DIR)/include);
	touch $(ZLIB_DIR)/.configured;

$(ZLIB_DIR)/libz.so.1.1.4: $(ZLIB_DIR)/.configured
	$(MAKE) LDSHARED="$(TARGET_CROSS)gcc --shared" CFLAGS=$(ZLIB_CFLAGS) CC=$(TARGET_CC1) -C $(ZLIB_DIR) all libz.a;
	touch -c $(ZLIB_DIR)/libz.so.1.1.4

$(STAGING_DIR)/lib/libz.so.1.1.4: $(ZLIB_DIR)/libz.so.1.1.4
	cp -a $(ZLIB_DIR)/libz.a $(STAGING_DIR)/lib;
	cp -a $(ZLIB_DIR)/zlib.h $(STAGING_DIR)/include;
	cp -a $(ZLIB_DIR)/zconf.h $(STAGING_DIR)/include;
	cp -a $(ZLIB_DIR)/libz.so* $(STAGING_DIR)/lib;
	(cd $(STAGING_DIR)/lib; ln -fs libz.so.1.1.4 libz.so.1);
	touch -c $(STAGING_DIR)/lib/libz.so.1.1.4

$(TARGET_DIR)/lib/libz.so.1.1.4: $(STAGING_DIR)/lib/libz.so.1.1.4
	cp -a $(STAGING_DIR)/lib/libz.so* $(TARGET_DIR)/lib;
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libz.so*
	touch -c $(TARGET_DIR)/lib/libz.so.1.1.4

zlib: uclibc $(TARGET_DIR)/lib/libz.so.1.1.4

zlib-clean:
	rm -f $(TARGET_DIR)/lib/libz.so*
	-make -C $(ZLIB_DIR) clean

zlib-dirclean:
	rm -rf $(ZLIB_DIR)

