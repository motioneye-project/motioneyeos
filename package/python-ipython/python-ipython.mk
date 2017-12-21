################################################################################
#
# python-ipython
#
################################################################################

PYTHON_IPYTHON_VERSION = 5.4.0
PYTHON_IPYTHON_SOURCE = ipython-$(PYTHON_IPYTHON_VERSION).tar.gz
PYTHON_IPYTHON_SITE = https://pypi.python.org/packages/36/cd/765f53135bbbbcd691858aba3af124453a230fe0c752f009f69012fce5d5
PYTHON_IPYTHON_LICENSE = BSD-3-Clause
PYTHON_IPYTHON_LICENSE_FILES = COPYING.rst
PYTHON_IPYTHON_SETUP_TYPE = distutils

$(eval $(python-package))
