################################################################################
#
# python-numpy
#
################################################################################

PYTHON_NUMPY_VERSION = 1.8.0
PYTHON_NUMPY_SOURCE = numpy-$(PYTHON_NUMPY_VERSION).tar.gz
PYTHON_NUMPY_SITE = http://downloads.sourceforge.net/numpy
PYTHON_NUMPY_LICENSE = BSD-3-Clause
PYTHON_NUMPY_LICENSE_FILES = LICENSE.txt
PYTHON_NUMPY_SETUP_TYPE = distutils

ifeq ($(BR2_PACKAGE_CLAPACK),y)
PYTHON_NUMPY_DEPENDENCIES += clapack
PYTHON_NUMPY_SITE_CFG_LIBS += blas lapack
endif

PYTHON_NUMPY_BUILD_OPTS = --fcompiler=None

define PYTHON_NUMPY_CONFIGURE_CMDS
	-rm -f $(@D)/site.cfg
	echo "[DEFAULT]" >> $(@D)/site.cfg
	echo "library_dirs = $(STAGING_DIR)/usr/lib" >> $(@D)/site.cfg
	echo "include_dirs = $(STAGING_DIR)/usr/include" >> $(@D)/site.cfg
	echo "libraries =" $(subst $(space),$(comma),$(PYTHON_NUMPY_SITE_CFG_LIBS)) >> $(@D)/site.cfg
endef

# Some package may include few headers from NumPy, so let's install it
# in the staging area.
PYTHON_NUMPY_INSTALL_STAGING = YES

$(eval $(python-package))
