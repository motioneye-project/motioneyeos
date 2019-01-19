################################################################################
#
# python-cython
#
################################################################################

PYTHON_CYTHON_VERSION = 0.29.3
PYTHON_CYTHON_SOURCE = Cython-$(PYTHON_CYTHON_VERSION).tar.gz
PYTHON_CYTHON_SITE = https://files.pythonhosted.org/packages/02/24/f73045afb049295b34ac55aaf6ea1592604cda3749632a22e563e66604a3
PYTHON_CYTHON_SETUP_TYPE = setuptools
PYTHON_CYTHON_LICENSE = Apache-2.0
PYTHON_CYTHON_LICENSE_FILES = COPYING.txt LICENSE.txt

$(eval $(host-python-package))
