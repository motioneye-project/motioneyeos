################################################################################
#
# python-enum
#
################################################################################

PYTHON_ENUM_VERSION = 0.4.4
PYTHON_ENUM_SOURCE = enum-$(PYTHON_ENUM_VERSION).tar.gz
PYTHON_ENUM_SITE = http://pypi.python.org/packages/source/e/enum
PYTHON_ENUM_SETUP_TYPE = setuptools
PYTHON_ENUM_LICENSE = GPLv2+ or Python software foundation license v2
PYTHON_ENUM_LICENSE_FILES = LICENSE.GPL LICENSE.PSF

$(eval $(python-package))
