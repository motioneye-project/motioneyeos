################################################################################
#
# python-ipython
#
################################################################################

PYTHON_IPYTHON_VERSION = 2.1.0
PYTHON_IPYTHON_SOURCE = ipython-$(PYTHON_IPYTHON_VERSION).tar.gz
PYTHON_IPYTHON_SITE = https://pypi.python.org/packages/source/i/ipython
PYTHON_IPYTHON_LICENSE = BSD-3c
PYTHON_IPYTHON_LICENSE_FILES = COPYING.rst
PYTHON_IPYTHON_SETUP_TYPE = distutils

$(eval $(python-package))
