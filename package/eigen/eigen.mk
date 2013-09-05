################################################################################
#
# eigen
#
################################################################################

# version 3.2
EIGEN_VERSION = ffa86ffb5570
EIGEN_SITE    = https://bitbucket.org/eigen/eigen/
EIGEN_SITE_METHOD = hg
EIGEN_LICENSE = MPL2, BSD-3c, LGPLv2.1
EIGEN_LICENSE_FILES = COPYING.MPL2 COPYING.BSD COPYING.LGPL COPYING.README
EIGEN_INSTALL_STAGING = YES
EIGEN_INSTALL_TARGET = NO

# This package only consists of headers that need to be
# copied over to the sysroot for compile time use
define EIGEN_INSTALL_STAGING_CMDS
	$(RM) -r $(STAGING_DIR)/usr/include/Eigen
	cp -a $(@D)/Eigen $(STAGING_DIR)/usr/include/
endef

$(eval $(generic-package))
