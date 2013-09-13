################################################################################
#
# grantlee
#
################################################################################

GRANTLEE_VERSION = 0.2.0
GRANTLEE_SITE = http://downloads.grantlee.org
GRANTLEE_INSTALL_STAGING = YES
GRANTLEE_DEPENDENCIES =  qt

$(eval $(cmake-package))
