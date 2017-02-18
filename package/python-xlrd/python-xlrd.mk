################################################################################
#
# python-xlrd
#
################################################################################

PYTHON_XLRD_VERSION = 1.0.0
PYTHON_XLRD_SOURCE = xlrd-$(PYTHON_XLRD_VERSION).tar.gz
PYTHON_XLRD_SITE = https://pypi.python.org/packages/42/85/25caf967c2d496067489e0bb32df069a8361e1fd96a7e9f35408e56b3aab
PYTHON_XLRD_SETUP_TYPE = setuptools
PYTHON_XLRD_LICENSE = BSD-3c
PYTHON_XLRD_LICENSE_FILES = xlrd/licences.py

$(eval $(python-package))
