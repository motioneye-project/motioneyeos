################################################################################
#
# python-serial-asyncio
#
################################################################################

PYTHON_SERIAL_ASYNCIO_VERSION = 0.4
PYTHON_SERIAL_ASYNCIO_SOURCE = pyserial-asyncio-$(PYTHON_SERIAL_ASYNCIO_VERSION).tar.gz
PYTHON_SERIAL_ASYNCIO_SITE = https://files.pythonhosted.org/packages/41/3f/e26f71269cbc0890a527a736d9afc5c0d5838a2c188be680558d635b7dc2
PYTHON_SERIAL_ASYNCIO_LICENSE = BSD-3-Clause
PYTHON_SERIAL_ASYNCIO_LICENSE_FILES = LICENSE.txt
PYTHON_SERIAL_ASYNCIO_SETUP_TYPE = setuptools

$(eval $(python-package))
