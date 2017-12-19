################################################################################
#
# python-pysnmp-mibs
#
################################################################################

PYTHON_PYSNMP_MIBS_VERSION = 0.1.6
PYTHON_PYSNMP_MIBS_SOURCE = pysnmp-mibs-$(PYTHON_PYSNMP_MIBS_VERSION).tar.gz
PYTHON_PYSNMP_MIBS_SITE = https://pypi.python.org/packages/bf/7c/99ab192af934ed5d41ceef92a1b949b41652f29b46241b902ffec55642f4
PYTHON_PYSNMP_MIBS_SETUP_TYPE = setuptools
PYTHON_PYSNMP_MIBS_LICENSE = BSD-3-Clause
PYTHON_PYSNMP_MIBS_LICENSE_FILES = LICENSE.txt

PYTHON_PYSNMP_MIBS_DEPENDENCIES = python-pysnmp

$(eval $(python-package))
