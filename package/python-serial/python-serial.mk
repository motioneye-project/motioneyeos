################################################################################
#
# python-serial
#
################################################################################

PYTHON_SERIAL_VERSION = 3.1
PYTHON_SERIAL_SOURCE = pyserial-$(PYTHON_SERIAL_VERSION).tar.gz
PYTHON_SERIAL_SITE = https://pypi.python.org/packages/ce/9c/694ce79a9d4a164e109aeba1a40fba23336f3b7554978553e22a5d41d54d
PYTHON_SERIAL_LICENSE = Python Software Foundation License
PYTHON_SERIAL_LICENSE_FILES = LICENSE.txt
PYTHON_SERIAL_SETUP_TYPE = setuptools

$(eval $(python-package))
