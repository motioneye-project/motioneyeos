################################################################################
#
# python-xlwt
#
################################################################################

PYTHON_XLWT_VERSION = 1.1.2
PYTHON_XLWT_SOURCE = xlwt-$(PYTHON_XLWT_VERSION).tar.gz
PYTHON_XLWT_SITE = https://pypi.python.org/packages/0b/69/644313df86e6375ec2c6b34ec8ac544b9cc7803b7d943223d32811860f3d
PYTHON_XLWT_SETUP_TYPE = setuptools
PYTHON_XLWT_LICENSE = BSD-3c, BSD-4c
PYTHON_XLWT_LICENSE_FILES = docs/licenses.rst

$(eval $(python-package))
