################################################################################
#
# python-zeroconf
#
################################################################################

PYTHON_ZEROCONF_VERSION = 0.23.0
PYTHON_ZEROCONF_SOURCE = zeroconf-$(PYTHON_ZEROCONF_VERSION).tar.gz
PYTHON_ZEROCONF_SITE = https://files.pythonhosted.org/packages/d7/25/8bbdd4857820e0cdc380c7e0c3543dc01a55247a1d831c712571783e74ec
PYTHON_ZEROCONF_SETUP_TYPE = setuptools
PYTHON_ZEROCONF_LICENSE = LGPL-2.1+
PYTHON_ZEROCONF_LICENSE_FILES = COPYING

$(eval $(python-package))
