################################################################################
#
# grantlee
#
################################################################################

GRANTLEE_VERSION = 0.2.0
GRANTLEE_SITE = http://downloads.grantlee.org
GRANTLEE_INSTALL_STAGING = YES
GRANTLEE_DEPENDENCIES = qt
GRANTLEE_LICENSE = LGPLv2.1+
GRANTLEE_LICENSE_FILES = COPYING.LIB

$(eval $(cmake-package))
