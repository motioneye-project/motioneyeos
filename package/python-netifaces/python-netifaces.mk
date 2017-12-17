################################################################################
#
# python-netifaces
#
################################################################################

PYTHON_NETIFACES_VERSION = 0.10.6
PYTHON_NETIFACES_SOURCE = netifaces-$(PYTHON_NETIFACES_VERSION).tar.gz
PYTHON_NETIFACES_SITE = https://pypi.python.org/packages/72/01/ba076082628901bca750bf53b322a8ff10c1d757dc29196a8e6082711c9d
PYTHON_NETIFACES_LICENSE = MIT
PYTHON_NETIFACES_LICENSE_FILES = README.rst
PYTHON_NETIFACES_SETUP_TYPE = setuptools

$(eval $(python-package))
