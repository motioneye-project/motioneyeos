################################################################################
#
# armadillo
#
################################################################################

ARMADILLO_VERSION = 9.850.1
ARMADILLO_SOURCE = armadillo-$(ARMADILLO_VERSION).tar.xz
ARMADILLO_SITE = https://downloads.sourceforge.net/project/arma
ARMADILLO_DEPENDENCIES = clapack
ARMADILLO_INSTALL_STAGING = YES
ARMADILLO_LICENSE = Apache-2.0
ARMADILLO_LICENSE_FILES = LICENSE.txt

ARMADILLO_CONF_OPTS = -DDETECT_HDF5=false

$(eval $(cmake-package))
