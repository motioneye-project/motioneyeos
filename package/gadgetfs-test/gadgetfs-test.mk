#############################################################
#
# gadgetfs-test
#
#############################################################
GADGETFS_TEST_SOURCE=gadgetfs-test.tar.bz2
GADGETFS_TEST_SITE=http://avr32linux.org/twiki/pub/Main/GadgetFsTest/

GADGETFS_TEST_MAKEOPTS = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"

ifeq ($(BR2_PACKAGE_GADGETFS_TEST_USE_AIO),y)
GADGETFS_TEST_DEPENDENCIES = libaio
GADGETFS_TEST_MAKEOPTS+=USE_AIO=y
endif

define GADGETFS_TEST_BUILD_CMDS
	$(MAKE) -C $(@D) $(GADGETFS_TEST_MAKEOPTS)
endef

define GADGETFS_TEST_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) prefix=/usr install
endef

define GADGETFS_TEST_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/bin/gadgetfs-test
endef

define GADGETFS_TEST_CLEAN_CMDS
	-$(MAKE) -C $(@D) $(GADGETFS_TEST_MAKEOPTS) clean
endef

$(eval $(generic-package))
