################################################################################
#
# python-numpy
#
################################################################################

PYTHON_NUMPY_VERSION = 1.18.2
PYTHON_NUMPY_SOURCE = numpy-$(PYTHON_NUMPY_VERSION).tar.gz
PYTHON_NUMPY_SITE = https://github.com/numpy/numpy/releases/download/v$(PYTHON_NUMPY_VERSION)
PYTHON_NUMPY_LICENSE = BSD-3-Clause, BSD-2-Clause, PSF, Apache-2.0, MIT, Zlib
PYTHON_NUMPY_LICENSE_FILES = LICENSE.txt doc/sphinxext/LICENSE.txt \
			doc/scipy-sphinx-theme/LICENSE.txt \
			numpy/linalg/lapack_lite/LICENSE.txt \
			tools/npy_tempita/license.txt \
			numpy/core/src/multiarray/dragon4.c
PYTHON_NUMPY_SETUP_TYPE = setuptools
PYTHON_NUMPY_DEPENDENCIES = host-python-cython
HOST_PYTHON_NUMPY_DEPENDENCIES = host-python-cython

ifeq ($(BR2_PACKAGE_CLAPACK),y)
PYTHON_NUMPY_DEPENDENCIES += clapack
else
PYTHON_NUMPY_ENV += BLAS=None LAPACK=None
endif

PYTHON_NUMPY_BUILD_OPTS = --fcompiler=None

define PYTHON_NUMPY_CONFIGURE_CMDS
	-rm -f $(@D)/site.cfg
	echo "[DEFAULT]" >> $(@D)/site.cfg
	echo "library_dirs = $(STAGING_DIR)/usr/lib" >> $(@D)/site.cfg
	echo "include_dirs = $(STAGING_DIR)/usr/include" >> $(@D)/site.cfg
endef

# Some package may include few headers from NumPy, so let's install it
# in the staging area.
PYTHON_NUMPY_INSTALL_STAGING = YES

$(eval $(python-package))
$(eval $(host-python-package))
