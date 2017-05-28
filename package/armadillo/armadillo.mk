################################################################################
#
# armadillo
#
################################################################################

ARMADILLO_VERSION = 6.500.4
# upstream removed tarball from
# http://downloads.sourceforge.net/project/arma
ARMADILLO_SITE = https://ftp.fau.de/macports/distfiles/armadillo
ARMADILLO_DEPENDENCIES = clapack
ARMADILLO_INSTALL_STAGING = YES
ARMADILLO_LICENSE = MPL-2.0
ARMADILLO_LICENSE_FILES = LICENSE.txt

$(eval $(cmake-package))
