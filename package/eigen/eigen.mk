################################################################################
#
# eigen
#
################################################################################

EIGEN_VERSION = 3.2.5
EIGEN_SITE = https://bitbucket.org/eigen/eigen
EIGEN_SITE_METHOD = hg
EIGEN_LICENSE = MPL2, BSD-3c, LGPLv2.1
EIGEN_LICENSE_FILES = COPYING.MPL2 COPYING.BSD COPYING.LGPL COPYING.README
EIGEN_INSTALL_STAGING = YES
EIGEN_INSTALL_TARGET = NO
EIGEN_DEST_DIR = $(STAGING_DIR)/usr/include/eigen3

ifeq ($(BR2_PACKAGE_EIGEN_UNSUPPORTED_MODULES),y)
define EIGEN_INSTALL_UNSUPPORTED_MODULES_CMDS
	mkdir -p $(EIGEN_DEST_DIR)/unsupported
	cp -a $(@D)/unsupported/Eigen $(EIGEN_DEST_DIR)/unsupported
endef
endif

# This package only consists of headers that need to be
# copied over to the sysroot for compile time use
define EIGEN_INSTALL_STAGING_CMDS
	$(RM) -r $(EIGEN_DEST_DIR)
	mkdir -p $(EIGEN_DEST_DIR)
	cp -a $(@D)/Eigen $(EIGEN_DEST_DIR)
	$(EIGEN_INSTALL_UNSUPPORTED_MODULES_CMDS)
endef

$(eval $(generic-package))
