################################################################################
#
# gtest
#
################################################################################

GTEST_VERSION = 1.7.0
GTEST_SOURCE = gtest-$(GTEST_VERSION).zip
GTEST_SITE = http://googletest.googlecode.com/files/
GTEST_INSTALL_STAGING = YES
GTEST_INSTALL_TARGET = NO
GTEST_LICENSE = BSD-3c
GTEST_LICENSE_FILES = LICENSE

define GTEST_EXTRACT_CMDS
	unzip $(DL_DIR)/$(GTEST_SOURCE) -d $(BUILD_DIR)
endef

define GTEST_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libgtest.a $(STAGING_DIR)/usr/lib/libgtest.a
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include/gtest/
	cp -rp $(@D)/include/gtest/* $(STAGING_DIR)/usr/include/gtest/
endef

$(eval $(cmake-package))
