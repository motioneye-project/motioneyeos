################################################################################
#
# python-ipython-genutils
#
################################################################################

PYTHON_IPYTHON_GENUTILS_VERSION = 0.2.0
PYTHON_IPYTHON_GENUTILS_SOURCE = ipython_genutils-$(PYTHON_IPYTHON_GENUTILS_VERSION).tar.gz
PYTHON_IPYTHON_GENUTILS_SITE = https://pypi.python.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399
PYTHON_IPYTHON_GENUTILS_LICENSE = BSD-3-Clause
PYTHON_IPYTHON_GENUTILS_LICENSE_FILES = COPYING.md
PYTHON_IPYTHON_GENUTILS_SETUP_TYPE = distutils

$(eval $(python-package))
