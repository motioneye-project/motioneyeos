################################################################################
#
# python-netifaces
#
################################################################################

PYTHON_NETIFACES_VERSION = 0.10.5
PYTHON_NETIFACES_SOURCE = netifaces-$(PYTHON_NETIFACES_VERSION).tar.gz
PYTHON_NETIFACES_SITE = https://pypi.python.org/packages/a7/4c/8e0771a59fd6e55aac993a7cc1b6a0db993f299514c464ae6a1ecf83b31d
PYTHON_NETIFACES_LICENSE = MIT
PYTHON_NETIFACES_LICENSE_FILES = README.rst
PYTHON_NETIFACES_SETUP_TYPE = setuptools

$(eval $(python-package))
