################################################################################
#
# doxygen
#
################################################################################

DOXYGEN_VERSION = 1.8.17
DOXYGEN_SOURCE = doxygen-$(DOXYGEN_VERSION).src.tar.gz
DOXYGEN_SITE = http://doxygen.nl/files
DOXYGEN_LICENSE = GPL-2.0
DOXYGEN_LICENSE_FILES = LICENSE
HOST_DOXYGEN_DEPENDENCIES = host-flex host-bison

$(eval $(host-cmake-package))
