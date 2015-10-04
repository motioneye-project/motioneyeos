################################################################################
#
# python-pysnmp
#
################################################################################

PYTHON_PYSNMP_VERSION = 4.2.4
PYTHON_PYSNMP_SOURCE = pysnmp-$(PYTHON_PYSNMP_VERSION).tar.gz
PYTHON_PYSNMP_SITE = https://pypi.python.org/packages/source/p/pysnmp
PYTHON_PYSNMP_SETUP_TYPE = setuptools

PYTHON_PYSNMP_LICENSE = BSD-3c
PYTHON_PYSNMP_LICENSE_FILES = LICENSE

PYTHON_PYSNMP_DEPENDENCIES = python-pyasn python-pycrypto

$(eval $(python-package))
