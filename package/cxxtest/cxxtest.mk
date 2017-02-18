#######################################################################################
#
# cxxtest
#
#######################################################################################

CXXTEST_VERSION = 4.4
CXXTEST_SITE = https://github.com/CxxTest/cxxtest/releases/download/$(CXXTEST_VERSION)
CXXTEST_LICENSE = LGPLv3
CXXTEST_LICENSE_FILES = COPYING
CXXTEST_INSTALL_STAGING = YES
CXXTEST_INSTALL_TARGET = NO
CXXTEST_DEPENDENCIES = host-cxxtest
HOST_CXXTEST_SETUP_TYPE = setuptools
HOST_CXXTEST_SUBDIR = python

# Copy CxxTest header files to staging directory
define CXXTEST_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 -d $(STAGING_DIR)/usr/include/cxxtest
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/include/cxxtest $(@D)/cxxtest/*
endef

# CxxTest uses python infrastructure as the build system. It consists of two parts:
# 1. cxxtestgen tool to process tests defined in header files to generate C++ source
# files. cxxtestgen is built as a host package, so that it can be used natively.
# 2. A set of header files which are installed in staging directory. This will be
# used in cross-compiling test harness to generate executable which will run on target.

$(eval $(generic-package))
$(eval $(host-python-package))
