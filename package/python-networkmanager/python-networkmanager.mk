################################################################################
#
# python-networkmanager
#
################################################################################

PYTHON_NETWORKMANAGER_VERSION = 1.2.1
PYTHON_NETWORKMANAGER_SITE = https://pypi.python.org/packages/e7/b1/09993250ceea9e03bc65fbabcd5286540200292c011b22237b2963c11471
PYTHON_NETWORKMANAGER_SETUP_TYPE = distutils
PYTHON_NETWORKMANAGER_LICENSE = GPL-3.0+
PYTHON_NETWORKMANAGER_LICENSE_FILES = COPYING
PYTHON_NETWORKMANAGER_DEPENDENCIES = dbus-python

$(eval $(python-package))
