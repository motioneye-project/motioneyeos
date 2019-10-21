################################################################################
#
# python-pymodbus
#
################################################################################

PYTHON_PYMODBUS_VERSION = 2.2.0
PYTHON_PYMODBUS_SOURCE = pymodbus-$(PYTHON_PYMODBUS_VERSION).tar.gz
PYTHON_PYMODBUS_SITE = https://files.pythonhosted.org/packages/d5/24/9d24899fd9fbea9e9bde5d0073e00649e7eb6f3bbec2bc1fec8df282fa53
PYTHON_PYMODBUS_SETUP_TYPE = setuptools
PYTHON_PYMODBUS_LICENSE = BSD-3-Clause
PYTHON_PYMODBUS_LICENSE_FILES = doc/LICENSE

$(eval $(python-package))
