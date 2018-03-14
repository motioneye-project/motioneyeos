################################################################################
#
# python-pymodbus
#
################################################################################

PYTHON_PYMODBUS_VERSION = v1.4.0
PYTHON_PYMODBUS_SITE = $(call github,riptideio,pymodbus,$(PYTHON_PYMODBUS_VERSION))
PYTHON_PYMODBUS_SETUP_TYPE = setuptools
PYTHON_PYMODBUS_LICENSE = BSD-3-Clause
PYTHON_PYMODBUS_LICENSE_FILES = doc/LICENSE

$(eval $(python-package))
