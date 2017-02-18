################################################################################
#
# flann
#
################################################################################

FLANN_VERSION = 3645f0c30a47267e56e5acdecfc7bac2b76bc3d5
FLANN_SITE = $(call github,mariusmuja,flann,$(FLANN_VERSION))
FLANN_INSTALL_STAGING = YES
FLANN_LICENSE = BSD-3c
FLANN_LICENSE_FILES = COPYING
FLANN_CONF_OPTS = \
	-DBUILD_C_BINDINGS=ON \
	-DBUILD_PYTHON_BINDINGS=OFF \
	-DBUILD_MATLAB_BINDINGS=OFF \
	-DBUILD_EXAMPLES=$(if $(BR2_PACKAGE_FLANN_EXAMPLES),ON,OFF) \
	-DUSE_OPENMP=$(if $(BR2_GCC_ENABLE_OPENMP),ON,OFF) \
	-DPYTHON_EXECUTABLE=OFF

$(eval $(cmake-package))
