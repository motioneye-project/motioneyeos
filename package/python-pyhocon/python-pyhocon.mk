################################################################################
#
# python-pyhocon
#
################################################################################

PYTHON_PYHOCON_VERSION = 0.3.51
PYTHON_PYHOCON_SOURCE = pyhocon-$(PYTHON_PYHOCON_VERSION).tar.gz
PYTHON_PYHOCON_SITE = https://files.pythonhosted.org/packages/3f/35/34e16968df0b8b65d3696d80b8add0aaffd4f0461c1ef3c0f066fdc747e8
PYTHON_PYHOCON_LICENSE = Apache-2.0
PYTHON_PYHOCON_LICENSE_FILES = LICENSE
PYTHON_PYHOCON_SETUP_TYPE = setuptools

$(eval $(python-package))
