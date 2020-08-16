################################################################################
#
# python-xlwt
#
################################################################################

PYTHON_XLWT_VERSION = 1.3.0
PYTHON_XLWT_SOURCE = xlwt-$(PYTHON_XLWT_VERSION).tar.gz
PYTHON_XLWT_SITE = https://files.pythonhosted.org/packages/06/97/56a6f56ce44578a69343449aa5a0d98eefe04085d69da539f3034e2cd5c1
PYTHON_XLWT_SETUP_TYPE = setuptools
PYTHON_XLWT_LICENSE = BSD-3-Clause, BSD-4-Clause
PYTHON_XLWT_LICENSE_FILES = docs/licenses.rst

$(eval $(python-package))
