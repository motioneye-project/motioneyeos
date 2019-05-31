################################################################################
#
# python-txdbus
#
################################################################################

PYTHON_TXDBUS_VERSION = 1.1.0
PYTHON_TXDBUS_SOURCE = txdbus-$(PYTHON_TXDBUS_VERSION).tar.gz
PYTHON_TXDBUS_SITE = https://files.pythonhosted.org/packages/8e/7c/0b8726b82943ae99dc71b8fe20e2e0beb7feb4ef61105865021a64f08b16
PYTHON_TXDBUS_SETUP_TYPE = setuptools
PYTHON_TXDBUS_LICENSE = MIT

$(eval $(python-package))
