################################################################################
#
# gtest
#
################################################################################

GTEST_VERSION = 1.10.0
GTEST_SITE = $(call github,google,googletest,release-$(GTEST_VERSION))
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
	$(HOST_DIR)/lib/python$(HOST_GTEST_PYTHON_VERSION)/site-packages

# While it is possible to build gtest as shared library, using this gtest shared
# library requires to set some special configure option in the project using
# gtest.
# So, force to build gtest as a static library.
#
# For further details, refer to the explaination given in the README file from
# the gtest sources.
GTEST_CONF_OPTS = -DBUILD_SHARED_LIBS=OFF

# Ensure that GTest is compiled with -fPIC to allow linking the static
# libraries with dynamically linked programs. This is not a requirement
# for most architectures but is mandatory for ARM.
ifeq ($(BR2_STATIC_LIBS),)
GTEST_CONF_OPTS += -DCMAKE_POSITION_INDEPENDENT_CODE=ON
endif

GTEST_CONF_OPTS += -DBUILD_GTEST=ON

# Generate the gtest-config script manually, since the CMake build system is
# not doing it.
define GTEST_INSTALL_GTEST_CONFIG
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
GTEST_POST_INSTALL_STAGING_HOOKS = GTEST_INSTALL_GTEST_CONFIG

ifeq ($(BR2_PACKAGE_GTEST_GMOCK),y)
GTEST_CONF_OPTS += -DBUILD_GMOCK=ON

# Generate the gmock-config script manually, since the CMake build system is
# not doing it.
define GTEST_INSTALL_GMOCK_CONFIG
	sed 's%@PACKAGE_TARNAME@%gmock%;\
		s%@PACKAGE_VERSION@%$(GTEST_VERSION)%;\
		s%@prefix@%$(STAGING_DIR)/usr%;\
		s%@exec_prefix@%$(STAGING_DIR)/usr%;\
		s%@libdir@%$(STAGING_DIR)/usr/lib%;\
		s%@includedir@%$(STAGING_DIR)/usr/include%;\
		s%@bindir@%$(STAGING_DIR)/usr/bin%;\
		s%@PTHREAD_CFLAGS@%%;\
		s%@PTHREAD_LIBS@%-lpthread%;' \
		$(@D)/googlemock/scripts/gmock-config.in \
		> $(STAGING_DIR)/usr/bin/gmock-config
	chmod +x $(STAGING_DIR)/usr/bin/gmock-config
endef
GTEST_POST_INSTALL_STAGING_HOOKS += GTEST_INSTALL_GMOCK_CONFIG
else
GTEST_CONF_OPTS += -DBUILD_GMOCK=OFF
endif

define HOST_GTEST_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/googlemock/scripts/generator/gmock_gen.py \
		$(HOST_DIR)/bin/gmock_gen
	cp -rp $(@D)/googlemock/scripts/generator/cpp \
		$(HOST_GTEST_GMOCK_PYTHONPATH)
endef

$(eval $(cmake-package))
# The host package does not build anything, just installs gmock_gen stuff, so
# it does not need to be a host-cmake-package.
$(eval $(host-generic-package))
