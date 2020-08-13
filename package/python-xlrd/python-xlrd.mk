################################################################################
#
# python-xlrd
#
################################################################################

PYTHON_XLRD_VERSION = 1.2.0
PYTHON_XLRD_SOURCE = xlrd-$(PYTHON_XLRD_VERSION).tar.gz
PYTHON_XLRD_SITE = https://files.pythonhosted.org/packages/aa/05/ec9d4fcbbb74bbf4da9f622b3b61aec541e4eccf31d3c60c5422ec027ce2
PYTHON_XLRD_SETUP_TYPE = setuptools
PYTHON_XLRD_LICENSE = BSD-3-Clause
PYTHON_XLRD_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
