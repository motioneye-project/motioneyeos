################################################################################
#
# python-xlsxwriter
#
################################################################################

PYTHON_XLSXWRITER_VERSION = 0.9.6
PYTHON_XLSXWRITER_SOURCE = XlsxWriter-$(PYTHON_XLSXWRITER_VERSION).tar.gz
PYTHON_XLSXWRITER_SITE = https://pypi.python.org/packages/c9/e0/c2b2f57bf53c84af3d2a41a82af7025828cb2bc8a312848a6ab7d018de56
PYTHON_XLSXWRITER_SETUP_TYPE = setuptools
PYTHON_XLSXWRITER_LICENSE = BSD-2c
PYTHON_XLSXWRITER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
