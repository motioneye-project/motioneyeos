#############################################################
#
# newt
#
#############################################################
NEWT_SOURCE=newt_0.50.17.orig.tar.gz
NEWT_SITE=http://ftp.debian.org/debian/pool/main/n/newt
NEWT_DIR=$(BUILD_DIR)/newt-0.50.17
NEWT_PATCH=$(SOURCE_DIR)/newt.patch
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
NEWT_CFLAGS="-Os -g -fPIC -D_FILE_OFFSET_BITS=64 -D__USE_FILE_OFFSET64"
else
NEWT_CFLAGS="-Os -g -fPIC"
endif

$(DL_DIR)/$(NEWT_SOURCE):
	$(WGET) -P $(DL_DIR) $(NEWT_SITE)/$(NEWT_SOURCE)

$(NEWT_DIR)/.source: $(DL_DIR)/$(NEWT_SOURCE) $(NEWT_PATCH)
	zcat $(DL_DIR)/$(NEWT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(NEWT_PATCH) | patch -p1 -d $(NEWT_DIR)
	(cd $(NEWT_DIR); autoconf);
	touch $(NEWT_DIR)/.source;

$(NEWT_DIR)/.configured: $(NEWT_DIR)/.source
	(cd $(NEWT_DIR); rm -rf config.cache; CC=$(TARGET_CC1) \
	./configure --shared --prefix=/usr --exec_prefix=$(STAGING_DIR)/usr/bin \
		--libdir=$(STAGING_DIR)/lib --includedir=$(STAGING_DIR)/include \
		--host=$(ARCH)-pc-linux-gnu);
	touch $(NEWT_DIR)/.configured;

$(NEWT_DIR)/libnewt.so.0.50.17: $(NEWT_DIR)/.configured
	$(MAKE) CFLAGS=$(NEWT_CFLAGS) CC=$(TARGET_CC1) -C  $(NEWT_DIR)
	touch -c $(NEWT_DIR)/libnewt.so.0.50.17

$(STAGING_DIR)/lib/libnewt.so.0.50.17: $(NEWT_DIR)/libnewt.so.0.50.17
	cp -a $(NEWT_DIR)/libnewt.a $(STAGING_DIR)/lib;
	cp -a $(NEWT_DIR)/newt.h $(STAGING_DIR)/include;
	cp -a $(NEWT_DIR)/libnewt.so* $(STAGING_DIR)/lib;
	(cd $(STAGING_DIR)/lib; ln -fs libnewt.so.0.50.17 libnewt.so);
	(cd $(STAGING_DIR)/lib; ln -fs libnewt.so.0.50.17 libnewt.so.0.50);
	touch -c $(STAGING_DIR)/lib/libnewt.so.0.50.17

$(TARGET_DIR)/lib/libnewt.so.0.50.17: $(STAGING_DIR)/lib/libnewt.so.0.50.17
	cp -a $(STAGING_DIR)/lib/libnewt.so* $(TARGET_DIR)/lib;
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libnewt.so*
	touch -c $(TARGET_DIR)/lib/libnewt.so.0.50.17

newt: uclibc slang $(TARGET_DIR)/lib/libnewt.so.0.50.17

newt-clean:
	rm -f $(TARGET_DIR)/lib/libnewt.so*
	-make -C $(NEWT_DIR) clean

newt-dirclean: slang-dirclean
	rm -rf $(NEWT_DIR)

