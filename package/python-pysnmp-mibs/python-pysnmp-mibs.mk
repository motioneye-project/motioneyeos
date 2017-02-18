################################################################################
#
# python-pysnmp-mibs
#
################################################################################

PYTHON_PYSNMP_MIBS_VERSION = 0.1.4
PYTHON_PYSNMP_MIBS_SOURCE = pysnmp-mibs-$(PYTHON_PYSNMP_MIBS_VERSION).tar.gz
PYTHON_PYSNMP_MIBS_SITE = https://pypi.python.org/packages/source/p/pysnmp-mibs
PYTHON_PYSNMP_MIBS_SETUP_TYPE = setuptools
PYTHON_PYSNMP_MIBS_LICENSE = BSD-3c
PYTHON_PYSNMP_MIBS_LICENSE_FILES = LICENSE

PYTHON_PYSNMP_MIBS_DEPENDENCIES = python-pysnmp

$(eval $(python-package))
