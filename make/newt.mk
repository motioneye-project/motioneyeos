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
NEWT_CFLAGS="-Os -g -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
else
NEWT_CFLAGS="-Os -g"
endif
NEWT_CFLAGS+="-fPIC"

$(DL_DIR)/$(NEWT_SOURCE):
	$(WGET) -P $(DL_DIR) $(NEWT_SITE)/$(NEWT_SOURCE)

$(NEWT_DIR)/.source: $(DL_DIR)/$(NEWT_SOURCE) $(NEWT_PATCH)
	zcat $(DL_DIR)/$(NEWT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(NEWT_PATCH) | patch -p1 -d $(NEWT_DIR)
	(cd $(NEWT_DIR); autoconf);
	touch $(NEWT_DIR)/.source;

$(NEWT_DIR)/.configured: $(NEWT_DIR)/.source
	(cd $(NEWT_DIR); rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-nls \
	);
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
	-$(MAKE) -C $(NEWT_DIR) clean

newt-dirclean: slang-dirclean
	rm -rf $(NEWT_DIR)

