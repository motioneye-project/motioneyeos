################################################################################
#
# python-txdbus
#
################################################################################

PYTHON_TXDBUS_VERSION = 1.1.1
PYTHON_TXDBUS_SOURCE = txdbus-$(PYTHON_TXDBUS_VERSION).tar.gz
PYTHON_TXDBUS_SITE = https://files.pythonhosted.org/packages/4a/68/dfd06f3f349999cbbb31eade239fe76fbff2d6a905eb7d20449666d1b2ce
PYTHON_TXDBUS_SETUP_TYPE = setuptools
PYTHON_TXDBUS_LICENSE = MIT

$(eval $(python-package))
