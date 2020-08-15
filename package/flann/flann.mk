################################################################################
#
# flann
#
################################################################################

FLANN_VERSION = 1.9.1
FLANN_SITE = $(call github,mariusmuja,flann,$(FLANN_VERSION))
FLANN_INSTALL_STAGING = YES
FLANN_LICENSE = BSD-3-Clause
FLANN_LICENSE_FILES = COPYING
FLANN_CONF_OPTS = \
	-DBUILD_C_BINDINGS=ON \
	-DBUILD_PYTHON_BINDINGS=OFF \
	-DBUILD_MATLAB_BINDINGS=OFF \
	-DBUILD_EXAMPLES=$(if $(BR2_PACKAGE_FLANN_EXAMPLES),ON,OFF) \
	-DUSE_OPENMP=$(if $(BR2_TOOLCHAIN_HAS_OPENMP),ON,OFF) \
	-DPYTHON_EXECUTABLE=OFF \
	-DCMAKE_DISABLE_FIND_PACKAGE_HDF5=TRUE

FLANN_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
FLANN_CXXFLAGS += -O0
endif

FLANN_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(FLANN_CXXFLAGS)"

$(eval $(cmake-package))
