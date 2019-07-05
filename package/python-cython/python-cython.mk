################################################################################
#
# python-cython
#
################################################################################

PYTHON_CYTHON_VERSION = 0.29.11
PYTHON_CYTHON_SOURCE = Cython-$(PYTHON_CYTHON_VERSION).tar.gz
PYTHON_CYTHON_SITE = https://files.pythonhosted.org/packages/87/26/6f8a63fda4743d9e405c17c2872ac3242b63b5eba79c475ddf1777f17b9e
PYTHON_CYTHON_SETUP_TYPE = setuptools
PYTHON_CYTHON_LICENSE = Apache-2.0
PYTHON_CYTHON_LICENSE_FILES = COPYING.txt LICENSE.txt

$(eval $(host-python-package))
