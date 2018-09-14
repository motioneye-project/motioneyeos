################################################################################
#
# python-pyasn1
#
################################################################################

PYTHON_PYASN1_VERSION = 0.4.4
PYTHON_PYASN1_SOURCE = pyasn1-$(PYTHON_PYASN1_VERSION).tar.gz
PYTHON_PYASN1_SITE = https://files.pythonhosted.org/packages/10/46/059775dc8e50f722d205452bced4b3cc965d27e8c3389156acd3b1123ae3
PYTHON_PYASN1_SETUP_TYPE = setuptools
PYTHON_PYASN1_LICENSE = BSD-2-Clause
PYTHON_PYASN1_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
