################################################################################
#
# python-pyasn1
#
################################################################################

PYTHON_PYASN1_VERSION = 0.4.7
PYTHON_PYASN1_SOURCE = pyasn1-$(PYTHON_PYASN1_VERSION).tar.gz
PYTHON_PYASN1_SITE = https://files.pythonhosted.org/packages/ca/f8/2a60a2c88a97558bdd289b6dc9eb75b00bd90ff34155d681ba6dbbcb46b2
PYTHON_PYASN1_SETUP_TYPE = setuptools
PYTHON_PYASN1_LICENSE = BSD-2-Clause
PYTHON_PYASN1_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
