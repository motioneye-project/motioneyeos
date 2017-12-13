################################################################################
#
# python-pyasn-modules
#
################################################################################

PYTHON_PYASN_MODULES_VERSION = 0.0.8
PYTHON_PYASN_MODULES_SOURCE = pyasn1-modules-$(PYTHON_PYASN_MODULES_VERSION).tar.gz
PYTHON_PYASN_MODULES_SITE = https://pypi.python.org/packages/source/p/pyasn1-modules
PYTHON_PYASN_MODULES_LICENSE = BSD-2-Clause
PYTHON_PYASN_MODULES_LICENSE_FILES = LICENSE.txt
PYTHON_PYASN_MODULES_SETUP_TYPE = setuptools

$(eval $(python-package))
