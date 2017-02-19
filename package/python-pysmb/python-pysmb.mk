################################################################################
#
# python-pysmb
#
################################################################################

PYTHON_PYSMB_VERSION = 1.1.19
PYTHON_PYSMB_SOURCE = pysmb-$(PYTHON_PYSMB_VERSION).tar.gz
PYTHON_PYSMB_SITE = https://pypi.python.org/packages/f9/e7/1fd7faaa946cc6b43ce85bb7a177b75a4718d9c5e291201fec00112b497c
PYTHON_PYSMB_LICENSE = libpng license
PYTHON_PYSMB_LICENSE_FILES = LICENSE
PYTHON_PYSMB_SETUP_TYPE = setuptools

$(eval $(python-package))
