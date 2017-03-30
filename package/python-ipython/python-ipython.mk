################################################################################
#
# python-ipython
#
################################################################################

PYTHON_IPYTHON_VERSION = 5.2.2
PYTHON_IPYTHON_SOURCE = ipython-$(PYTHON_IPYTHON_VERSION).tar.gz
PYTHON_IPYTHON_SITE = https://pypi.python.org/packages/6e/cf/c2a3ca5942e2d8084574157a8f818efafb7218204cd9e41166c92c452e07
PYTHON_IPYTHON_LICENSE = BSD-3-Clause
PYTHON_IPYTHON_LICENSE_FILES = COPYING.rst
PYTHON_IPYTHON_SETUP_TYPE = distutils

$(eval $(python-package))
