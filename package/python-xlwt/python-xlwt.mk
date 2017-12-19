################################################################################
#
# python-xlwt
#
################################################################################

PYTHON_XLWT_VERSION = 1.2.0
PYTHON_XLWT_SOURCE = xlwt-$(PYTHON_XLWT_VERSION).tar.gz
PYTHON_XLWT_SITE = https://pypi.python.org/packages/5b/8d/22b9ec552a1d7865de39f54bd15f9db09c72a6bf8ab77b11dcce4ae336bb
PYTHON_XLWT_SETUP_TYPE = setuptools
PYTHON_XLWT_LICENSE = BSD-3-Clause, BSD-4-Clause
PYTHON_XLWT_LICENSE_FILES = docs/licenses.rst

$(eval $(python-package))
