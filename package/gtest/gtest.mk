################################################################################
#
# gtest
#
################################################################################

GTEST_VERSION = 1.7.0
GTEST_SOURCE = gtest-$(GTEST_VERSION).zip
GTEST_SITE = http://googletest.googlecode.com/files
GTEST_INSTALL_STAGING = YES
GTEST_INSTALL_TARGET = NO
GTEST_LICENSE = BSD-3c
GTEST_LICENSE_FILES = LICENSE

# While it is possible to build gtest as shared library, using this gtest shared
# library requires to set some special configure option in the project using
# gtest.
# So, force to build gtest as a static library.
#
# For further details, refer to the explaination given in the README file from
# the gtest sources.
GTEST_CONF_OPTS = -DBUILD_SHARED_LIBS=OFF

define GTEST_EXTRACT_CMDS
	$(UNZIP) $(DL_DIR)/$(GTEST_SOURCE) -d $(BUILD_DIR)
endef

define GTEST_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libgtest.a $(STAGING_DIR)/usr/lib/libgtest.a
	$(INSTALL) -D -m 0755 $(@D)/libgtest_main.a $(STAGING_DIR)/usr/lib/libgtest_main.a
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include/gtest/
	cp -rp $(@D)/include/gtest/* $(STAGING_DIR)/usr/include/gtest/
endef

$(eval $(cmake-package))
