################################################################################
#
# python-pyasn1
#
################################################################################

PYTHON_PYASN1_VERSION = 0.4.5
PYTHON_PYASN1_SOURCE = pyasn1-$(PYTHON_PYASN1_VERSION).tar.gz
PYTHON_PYASN1_SITE = https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245
PYTHON_PYASN1_SETUP_TYPE = setuptools
PYTHON_PYASN1_LICENSE = BSD-2-Clause
PYTHON_PYASN1_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
