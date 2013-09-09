################################################################################
#
# fb-test-app
#
################################################################################

FB_TEST_APP_VERSION = v1.0.0
FB_TEST_APP_SITE = http://github.com/prpplague/fb-test-app/tarball/$(FB_TEST_APP_VERSION)
FB_TEST_APP_LICENSE = GPLv2
FB_TEST_APP_LICENSE_FILES = COPYING

define FB_TEST_APP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define FB_TEST_APP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/perf $(TARGET_DIR)/usr/bin/fb-test-perf
	$(INSTALL) -D -m 0755 $(@D)/rect $(TARGET_DIR)/usr/bin/fb-test-rect
	$(INSTALL) -D -m 0755 $(@D)/fb-test $(TARGET_DIR)/usr/bin/fb-test
	$(INSTALL) -D -m 0755 $(@D)/offset $(TARGET_DIR)/usr/bin/fb-test-offset
endef

define FB_TEST_APP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/fb-test-perf
	rm -f $(TARGET_DIR)/usr/bin/fb-test-rect
	rm -f $(TARGET_DIR)/usr/bin/fb-test
	rm -f $(TARGET_DIR)/usr/bin/fb-test-offset
endef

define FB_TEST_APP_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
