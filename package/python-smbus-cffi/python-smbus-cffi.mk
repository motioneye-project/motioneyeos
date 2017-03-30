################################################################################
#
# python-smbus-cffi
#
################################################################################

PYTHON_SMBUS_CFFI_VERSION = 0.5.1
PYTHON_SMBUS_CFFI_SOURCE = smbus-cffi-$(PYTHON_SMBUS_CFFI_VERSION).tar.gz
PYTHON_SMBUS_CFFI_SITE = https://pypi.python.org/packages/source/s/smbus-cffi
PYTHON_SMBUS_CFFI_SETUP_TYPE = setuptools
PYTHON_SMBUS_CFFI_LICENSE = GPL-2.0
PYTHON_SMBUS_CFFI_LICENSE_FILES = LICENSE
PYTHON_SMBUS_CFFI_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
