################################################################################
#
# python-pysnmp-apps
#
################################################################################

PYTHON_PYSNMP_APPS_VERSION = 0.3.3
PYTHON_PYSNMP_APPS_SOURCE = pysnmp-apps-$(PYTHON_PYSNMP_APPS_VERSION).tar.gz
PYTHON_PYSNMP_APPS_SITE = https://pypi.python.org/packages/source/p/pysnmp-apps
PYTHON_PYSNMP_APPS_SETUP_TYPE = setuptools
PYTHON_PYSNMP_APPS_LICENSE = BSD-3c
PYTHON_PYSNMP_APPS_LICENSE_FILES = LICENSE

PYTHON_PYSNMP_APPS_DEPENDENCIES = python-pysnmp

$(eval $(python-package))
