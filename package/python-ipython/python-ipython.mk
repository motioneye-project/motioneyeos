################################################################################
#
# python-ipython
#
################################################################################

PYTHON_IPYTHON_VERSION = 7.3.0
PYTHON_IPYTHON_SOURCE = ipython-$(PYTHON_IPYTHON_VERSION).tar.gz
PYTHON_IPYTHON_SITE = https://pypi.python.org/packages/82/0a/146b0f0f1ddf13ab8682aed5c5a42250cddf1082e193ec95b50b03b9f791
PYTHON_IPYTHON_LICENSE = BSD-3-Clause
PYTHON_IPYTHON_LICENSE_FILES = COPYING.rst LICENSE
PYTHON_IPYTHON_SETUP_TYPE = distutils

$(eval $(python-package))
