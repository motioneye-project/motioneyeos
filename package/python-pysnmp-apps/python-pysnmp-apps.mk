################################################################################
#
# python-pysnmp-apps
#
################################################################################

PYTHON_PYSNMP_APPS_VERSION = 0.5.3
PYTHON_PYSNMP_APPS_SOURCE = pysnmp-apps-$(PYTHON_PYSNMP_APPS_VERSION).tar.gz
PYTHON_PYSNMP_APPS_SITE = https://files.pythonhosted.org/packages/c2/1a/26f5f3732df2c7d34663a7f2fa6534b5b4ffae73a4a440b75864ec826ba6
PYTHON_PYSNMP_APPS_SETUP_TYPE = setuptools
PYTHON_PYSNMP_APPS_LICENSE = BSD-3-Clause
PYTHON_PYSNMP_APPS_LICENSE_FILES = LICENSE.txt
PYTHON_PYSNMP_APPS_DEPENDENCIES = python-pysnmp

$(eval $(python-package))
