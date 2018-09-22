################################################################################
#
# python-pysnmp
#
################################################################################

PYTHON_PYSNMP_VERSION = 4.4.6
PYTHON_PYSNMP_SOURCE = pysnmp-$(PYTHON_PYSNMP_VERSION).tar.gz
PYTHON_PYSNMP_SITE = https://files.pythonhosted.org/packages/8b/66/96a49bf1d64ad1e005a8455644523b7e09663a405eb20a4599fb219e4c95
PYTHON_PYSNMP_SETUP_TYPE = setuptools

PYTHON_PYSNMP_LICENSE = BSD-3-Clause
PYTHON_PYSNMP_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
