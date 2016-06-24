################################################################################
#
# gtest
#
################################################################################

# Make sure this remains the same version as the gmock one
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
	$(INSTALL) -D -m 0644 package/gtest/gtest.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/gtest.pc
	# Generate the gtest-config script manually, since the CMake
	# build system is not doing it.
	sed 's%@PACKAGE_TARNAME@%gtest%;\
		s%@PACKAGE_VERSION@%$(GTEST_VERSION)%;\
		s%@prefix@%$(STAGING_DIR)/usr%;\
		s%@exec_prefix@%$(STAGING_DIR)/usr%;\
		s%@libdir@%$(STAGING_DIR)/usr/lib%;\
		s%@includedir@%$(STAGING_DIR)/usr/include%;\
		s%@bindir@%$(STAGING_DIR)/usr/bin%;\
		s%@PTHREAD_CFLAGS@%%;\
		s%@PTHREAD_LIBS@%-lpthread%;' \
		$(@D)/scripts/gtest-config.in \
		> $(STAGING_DIR)/usr/bin/gtest-config
	chmod +x $(STAGING_DIR)/usr/bin/gtest-config
endef

$(eval $(cmake-package))
