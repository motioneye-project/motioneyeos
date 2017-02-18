################################################################################
#
# python-enum34
#
################################################################################

PYTHON_ENUM34_VERSION = 1.0.4
PYTHON_ENUM34_SOURCE = enum34-$(PYTHON_ENUM34_VERSION).tar.gz
PYTHON_ENUM34_SITE = http://pypi.python.org/packages/source/e/enum34
PYTHON_ENUM34_SETUP_TYPE = distutils
PYTHON_ENUM34_LICENSE = BSD-3c
PYTHON_ENUM34_LICENSE_FILES = enum/LICENSE

$(eval $(python-package))
