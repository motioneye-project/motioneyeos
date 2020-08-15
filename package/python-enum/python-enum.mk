################################################################################
#
# python-enum
#
################################################################################

PYTHON_ENUM_VERSION = 0.4.7
PYTHON_ENUM_SOURCE = enum-$(PYTHON_ENUM_VERSION).tar.gz
PYTHON_ENUM_SITE = https://files.pythonhosted.org/packages/02/a0/32e1d5a21b703f600183e205aafc6773577e16429af5ad3c3f9b956b07ca
PYTHON_ENUM_SETUP_TYPE = setuptools
PYTHON_ENUM_LICENSE = GPL-3.0+
PYTHON_ENUM_LICENSE_FILES = LICENSE.GPL-3

$(eval $(python-package))
