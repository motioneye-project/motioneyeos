################################################################################
#
# grantlee
#
################################################################################
GRANTLEE_VERSION = 5.1.0
GRANTLEE_SITE = http://downloads.grantlee.org
GRANTLEE_INSTALL_STAGING = YES
GRANTLEE_LICENSE = LGPLv2.1+
GRANTLEE_LICENSE_FILES = COPYING.LIB
GRANTLEE_DEPENDENCIES = qt5base qt5script

$(eval $(cmake-package))
