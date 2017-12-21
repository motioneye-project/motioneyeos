################################################################################
#
# python-serial
#
################################################################################

PYTHON_SERIAL_VERSION = 3.1
PYTHON_SERIAL_SOURCE = pyserial-$(PYTHON_SERIAL_VERSION).tar.gz
PYTHON_SERIAL_SITE = https://pypi.python.org/packages/ce/9c/694ce79a9d4a164e109aeba1a40fba23336f3b7554978553e22a5d41d54d
PYTHON_SERIAL_LICENSE = BSD-3-Clause
PYTHON_SERIAL_LICENSE_FILES = LICENSE.txt
PYTHON_SERIAL_SETUP_TYPE = setuptools

# aio.py is an experimental module, that is compatible only with
# Python 3, so remove it for Python 2 environment or it will
# cause compilation errors
ifeq ($(BR2_PACKAGE_PYTHON),y)
define PYTHON_SERIAL_REMOVE_AIO_PY
	rm $(@D)/serial/aio.py
endef
PYTHON_SERIAL_POST_EXTRACT_HOOKS = PYTHON_SERIAL_REMOVE_AIO_PY
endif

$(eval $(python-package))
