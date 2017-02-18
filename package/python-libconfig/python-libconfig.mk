################################################################################
#
# python-libconfig
#
################################################################################

PYTHON_LIBCONFIG_VERSION = b271c3d9dac938ad5cd29b67bd08cc5536a5a391
PYTHON_LIBCONFIG_SITE = $(call github,cnangel,python-libconfig,$(PYTHON_LIBCONFIG_VERSION))

PYTHON_LIBCONFIG_LICENSE = BSD
PYTHON_LIBCONFIG_LICENSE_FILES = README

PYTHON_LIBCONFIG_SETUP_TYPE = setuptools

PYTHON_LIBCONFIG_DEPENDENCIES = libconfig boost

$(eval $(python-package))
