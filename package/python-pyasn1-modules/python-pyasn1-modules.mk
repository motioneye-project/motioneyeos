################################################################################
#
# python-pyasn1-modules
#
################################################################################

PYTHON_PYASN1_MODULES_VERSION = 0.2.4
PYTHON_PYASN1_MODULES_SOURCE = pyasn1-modules-$(PYTHON_PYASN1_MODULES_VERSION).tar.gz
PYTHON_PYASN1_MODULES_SITE = https://files.pythonhosted.org/packages/bd/a5/ef7bf693e8a8f015386c9167483199f54f8a8ec01d1c737e05524f16e792
PYTHON_PYASN1_MODULES_SETUP_TYPE = setuptools
PYTHON_PYASN1_MODULES_LICENSE = BSD-2-Clause
PYTHON_PYASN1_MODULES_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
