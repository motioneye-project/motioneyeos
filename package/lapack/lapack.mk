################################################################################
#
# lapack
#
################################################################################

LAPACK_VERSION = 3.9.0
LAPACK_LICENSE = BSD-3-Clause
LAPACK_LICENSE_FILES = LICENSE
LAPACK_SITE = $(call github,Reference-LAPACK,lapack,v$(LAPACK_VERSION))
LAPACK_INSTALL_STAGING = YES
LAPACK_SUPPORTS_IN_SOURCE_BUILD = NO
LAPACK_CONF_OPTS = -DLAPACKE=ON -DCBLAS=ON

ifeq ($(BR2_PACKAGE_LAPACK_COMPLEX),y)
LAPACK_CONF_OPTS += -DBUILD_COMPLEX=ON -DBUILD_COMPLEX16=ON
else
LAPACK_CONF_OPTS += -DBUILD_COMPLEX=OFF -DBUILD_COMPLEX16=OFF
endif

$(eval $(cmake-package))
