################################################################################
#
# python-pyqrcode
#
################################################################################

PYTHON_PYQRCODE_VERSION = 1.2.1
PYTHON_PYQRCODE_SOURCE = PyQRCode-$(PYTHON_PYQRCODE_VERSION).tar.gz
PYTHON_PYQRCODE_SITE = https://pypi.python.org/packages/37/61/f07226075c347897937d4086ef8e55f0a62ae535e28069884ac68d979316
PYTHON_PYQRCODE_SETUP_TYPE = setuptools
PYTHON_PYQRCODE_LICENSE = BSD-3-Clause
PYTHON_PYQRCODE_LICENSE_FILES = setup.py

$(eval $(python-package))
