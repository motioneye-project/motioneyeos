################################################################################
#
# python-pysnmp
#
################################################################################

PYTHON_PYSNMP_VERSION = 4.3.3
PYTHON_PYSNMP_SOURCE = pysnmp-$(PYTHON_PYSNMP_VERSION).tar.gz
PYTHON_PYSNMP_SITE = https://pypi.python.org/packages/47/b5/c65b9b6fcc36d3f4caca30d3314920f1ca75f5ceecc1f6ae2538ede24511
PYTHON_PYSNMP_SETUP_TYPE = setuptools

PYTHON_PYSNMP_LICENSE = BSD-3-Clause
PYTHON_PYSNMP_LICENSE_FILES = LICENSE.txt

PYTHON_PYSNMP_DEPENDENCIES = python-pyasn python-pycrypto

$(eval $(python-package))
