################################################################################
#
# python-cython
#
################################################################################

PYTHON_CYTHON_VERSION = 0.29.4
PYTHON_CYTHON_SOURCE = Cython-$(PYTHON_CYTHON_VERSION).tar.gz
PYTHON_CYTHON_SITE = https://files.pythonhosted.org/packages/cf/e2/03af631ca4a2cf7bc392dd8785c7cc427bff3af4bf5864cdde734f80d052
PYTHON_CYTHON_SETUP_TYPE = setuptools
PYTHON_CYTHON_LICENSE = Apache-2.0
PYTHON_CYTHON_LICENSE_FILES = COPYING.txt LICENSE.txt

$(eval $(host-python-package))
