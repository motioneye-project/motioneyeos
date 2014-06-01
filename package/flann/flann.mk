################################################################################
#
# flann
#
################################################################################

FLANN_VERSION = d0c04f4d290ebc3aa9411a3322992d298e51f5aa
FLANN_SITE = $(call github,mariusmuja,flann,$(FLANN_VERSION))
FLANN_INSTALL_STAGING = YES
FLANN_LICENSE = BSD-3c
FLANN_LICENSE_FILES = COPYING
FLANN_CONF_OPT = \
	-DBUILD_C_BINDINGS=ON \
	-DBUILD_PYTHON_BINDINGS=OFF \
	-DBUILD_MATLAB_BINDINGS=OFF \
	-DBUILD_EXAMPLES=$(if $(BR2_PACKAGE_FLANN_EXAMPLES),ON,OFF) \
	-DBUILD_TESTS=OFF \
	-DBUILD_DOC=OFF \
	-DUSE_OPENMP=$(if $(BR2_GCC_ENABLE_OPENMP),ON,OFF) \
	-DPYTHON_EXECUTABLE=OFF

$(eval $(cmake-package))
