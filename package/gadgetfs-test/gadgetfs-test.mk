#############################################################
#
# gadgetfs-test
#
#############################################################
GADGETFS_TEST_SOURCE=gadgetfs-test.tar.bz2
GADGETFS_TEST_SITE=http://avr32linux.org/twiki/pub/Main/GadgetFsTest/
GADGETFS_TEST_DIR=$(BUILD_DIR)/gadgetfs-test

GADGETFS_TEST_MAKEOPTS:=CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"

ifeq ($(BR2_PACKAGE_GADGETFS_TEST_USE_AIO),y)
GADGETFS_TEST_MAKEOPTS+=USE_AIO=y
endif

$(DL_DIR)/$(GADGETFS_TEST_SOURCE):
	$(WGET) -P $(DL_DIR) $(GADGETFS_TEST_SITE)/$(GADGETFS_TEST_SOURCE)

$(GADGETFS_TEST_DIR)/.unpacked: $(DL_DIR)/$(GADGETFS_TEST_SOURCE)
	$(BZCAT) $(DL_DIR)/$(GADGETFS_TEST_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(GADGETFS_TEST_DIR) package/gadgetfs-test gadgetfs-test\*.patch
	touch $@

$(GADGETFS_TEST_DIR)/gadgetfs-test: $(GADGETFS_TEST_DIR)/.unpacked
	$(MAKE) -C $(GADGETFS_TEST_DIR) $(GADGETFS_TEST_MAKEOPTS)

$(TARGET_DIR)/usr/bin/gadgetfs-test: $(GADGETFS_TEST_DIR)/gadgetfs-test
	$(MAKE) -C $(GADGETFS_TEST_DIR) DESTDIR=$(TARGET_DIR) prefix=/usr install

ifeq ($(BR2_PACKAGE_GADGETFS_TEST_USE_AIO),y)
gadgetfs-test: uclibc libaio $(TARGET_DIR)/usr/bin/gadgetfs-test
else
gadgetfs-test: uclibc $(TARGET_DIR)/usr/bin/gadgetfs-test
endif

gadgetfs-test-source: $(DL_DIR)/$(GADGETFS_TEST_SOURCE)

gadgetfs-test-clean:
	-$(MAKE) -C $(GADGETFS_TEST_DIR) $(GADGETFS_TEST_MAKEOPTS) clean

gadgetfs-test-dirclean:
	rm -rf $(GADGETFS_TEST_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_GADGETFS_TEST),y)
TARGETS+=gadgetfs-test
endif
