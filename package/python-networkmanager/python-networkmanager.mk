################################################################################
#
# python-networkmanager
#
################################################################################

PYTHON_NETWORKMANAGER_VERSION = 0.9.13
PYTHON_NETWORKMANAGER_SITE = http://pypi.python.org/packages/source/p/python-networkmanager
PYTHON_NETWORKMANAGER_SETUP_TYPE = distutils
PYTHON_NETWORKMANAGER_LICENSE = GPLv3+
PYTHON_NETWORKMANAGER_LICENSE_FILES = COPYING
PYTHON_NETWORKMANAGER_DEPENDENCIES = dbus-python

$(eval $(python-package))
