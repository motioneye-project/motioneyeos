################################################################################
#
# python-pysmb
#
################################################################################

PYTHON_PYSMB_VERSION = 1.1.17
PYTHON_PYSMB_SOURCE = pysmb-$(PYTHON_PYSMB_VERSION).tar.gz
PYTHON_PYSMB_SITE = https://pypi.python.org/packages/source/p/pysmb
PYTHON_PYSMB_LICENSE = libpng license
PYTHON_PYSMB_LICENSE_FILES = LICENSE
PYTHON_PYSMB_SETUP_TYPE = setuptools

$(eval $(python-package))
