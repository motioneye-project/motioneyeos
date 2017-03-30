################################################################################
#
# gtest
#
################################################################################

GTEST_VERSION = release-1.8.0
GTEST_SITE = $(call github,google,googletest,$(GTEST_VERSION))
GTEST_INSTALL_STAGING = YES
GTEST_INSTALL_TARGET = NO
GTEST_LICENSE = BSD-3-Clause
GTEST_LICENSE_FILES = googletest/LICENSE

ifeq ($(BR2_PACKAGE_GTEST_GMOCK),y)
GTEST_DEPENDENCIES += host-gtest
endif

HOST_GTEST_LICENSE = Apache-2.0
HOST_GTEST_LICENSE_FILES = googlemock/scripts/generator/LICENSE
ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_GTEST_PYTHON_VERSION = $(PYTHON3_VERSION_MAJOR)
HOST_GTEST_DEPENDENCIES += host-python3
else
HOST_GTEST_PYTHON_VERSION = $(PYTHON_VERSION_MAJOR)
HOST_GTEST_DEPENDENCIES += host-python
endif

HOST_GTEST_GMOCK_PYTHONPATH = \
	$(HOST_DIR)/usr/lib/python$(HOST_GTEST_PYTHON_VERSION)/site-packages

# While it is possible to build gtest as shared library, using this gtest shared
# library requires to set some special configure option in the project using
# gtest.
# So, force to build gtest as a static library.
#
# For further details, refer to the explaination given in the README file from
# the gtest sources.
GTEST_CONF_OPTS = -DBUILD_SHARED_LIBS=OFF

GTEST_CONF_OPTS += -DBUILD_GTEST=ON

ifeq ($(BR2_PACKAGE_GTEST_GMOCK),y)
GTEST_CONF_OPTS += -DBUILD_GMOCK=ON
else
GTEST_CONF_OPTS += -DBUILD_GMOCK=OFF
endif

define GTEST_INSTALL_MISSING_FILES
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
		$(@D)/googletest/scripts/gtest-config.in \
		> $(STAGING_DIR)/usr/bin/gtest-config
	chmod +x $(STAGING_DIR)/usr/bin/gtest-config
endef

GTEST_POST_INSTALL_STAGING_HOOKS = GTEST_INSTALL_MISSING_FILES

ifeq ($(BR2_PACKAGE_GTEST_GMOCK),y)
define GTEST_GMOCK_INSTALL_MISSING_FILE
	$(INSTALL) -D -m 0644 package/gtest/gmock.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/gmock.pc
endef

GTEST_POST_INSTALL_STAGING_HOOKS += GTEST_GMOCK_INSTALL_MISSING_FILE
endif

define HOST_GTEST_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/googlemock/scripts/generator/gmock_gen.py \
		$(HOST_DIR)/usr/bin/gmock_gen
	cp -rp $(@D)/googlemock/scripts/generator/cpp \
		$(HOST_GTEST_GMOCK_PYTHONPATH)
endef

$(eval $(cmake-package))
# The host package does not build anything, just installs gmock_gen stuff, so
# it does not need to be a host-cmake-package.
$(eval $(host-generic-package))
