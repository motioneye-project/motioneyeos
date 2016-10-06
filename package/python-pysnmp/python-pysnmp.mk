################################################################################
#
# python-pysnmp
#
################################################################################

PYTHON_PYSNMP_VERSION = 4.3.2
PYTHON_PYSNMP_SOURCE = pysnmp-$(PYTHON_PYSNMP_VERSION).tar.gz
PYTHON_PYSNMP_SITE = https://pypi.python.org/packages/9e/77/795fcc9d9a01adcb6175a3bf6532132addb8904922afd7877a9930d89f2f
PYTHON_PYSNMP_SETUP_TYPE = setuptools

PYTHON_PYSNMP_LICENSE = BSD-3c
PYTHON_PYSNMP_LICENSE_FILES = LICENSE.txt

PYTHON_PYSNMP_DEPENDENCIES = python-pyasn python-pycrypto

$(eval $(python-package))
