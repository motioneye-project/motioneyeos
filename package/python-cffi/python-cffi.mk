################################################################################
#
# python-cffi
#
################################################################################

PYTHON_CFFI_VERSION = 0.8.2
PYTHON_CFFI_SOURCE = cffi-$(PYTHON_CFFI_VERSION).tar.gz
PYTHON_CFFI_SITE = https://pypi.python.org/packages/source/c/cffi
PYTHON_CFFI_SETUP_TYPE = setuptools
PYTHON_CFFI_DEPENDENCIES = host-pkgconf libffi
PYTHON_CFFI_LICENSE = MIT
PYTHON_CFFI_LICENSE_FILES = LICENSE

$(eval $(python-package))
