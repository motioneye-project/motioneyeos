################################################################################
#
# armadillo
#
################################################################################

ARMADILLO_VERSION_MAJOR = 4.000
ARMADILLO_VERSION = $(ARMADILLO_VERSION_MAJOR).4
ARMADILLO_SITE = http://downloads.sourceforge.net/project/arma/
ARMADILLO_DEPENDENCIES = clapack
ARMADILLO_INSTALL_STAGING = YES
ARMADILLO_LICENSE = MPLv2.0
ARMADILLO_LICENSE_FILES = LICENSE.txt

$(eval $(cmake-package))
