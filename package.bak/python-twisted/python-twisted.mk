################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 16.6.0
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://pypi.python.org/packages/dc/c0/a0114a6d7fa211c0904b0de931e8cafb5210ad824996cc6a9d67f3bae22c
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE
PYTHON_TWISTED_DEPENDENCIES = python-incremental

$(eval $(python-package))
