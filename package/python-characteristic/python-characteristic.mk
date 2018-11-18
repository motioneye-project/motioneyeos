################################################################################
#
# python-characteristic
#
################################################################################

PYTHON_CHARACTERISTIC_VERSION = 14.3.0
PYTHON_CHARACTERISTIC_SOURCE = characteristic-$(PYTHON_CHARACTERISTIC_VERSION).tar.gz
PYTHON_CHARACTERISTIC_SITE = https://pypi.python.org/packages/source/c/characteristic
PYTHON_CHARACTERISTIC_LICENSE = MIT
PYTHON_CHARACTERISTIC_LICENSE_FILES = LICENSE
PYTHON_CHARACTERISTIC_SETUP_TYPE = setuptools

$(eval $(python-package))
