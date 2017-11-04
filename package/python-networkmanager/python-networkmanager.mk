################################################################################
#
# python-networkmanager
#
################################################################################

PYTHON_NETWORKMANAGER_VERSION = 2.0.1
PYTHON_NETWORKMANAGER_SOURCE = python-networkmanager-$(PYTHON_NETWORKMANAGER_VERSION).tar.gz
PYTHON_NETWORKMANAGER_SITE = https://pypi.python.org/packages/d7/f9/5cbd99fd24a072875ce048e48d1754285f137aab447de8fee63b6cba990a
PYTHON_NETWORKMANAGER_SETUP_TYPE = setuptools
PYTHON_NETWORKMANAGER_LICENSE = Zlib
PYTHON_NETWORKMANAGER_LICENSE_FILES = COPYING

$(eval $(python-package))
