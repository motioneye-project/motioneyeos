################################################################################
#
# python-enum
#
################################################################################

PYTHON_ENUM_VERSION = 0.4.6
PYTHON_ENUM_SOURCE = enum-$(PYTHON_ENUM_VERSION).tar.gz
PYTHON_ENUM_SITE = https://pypi.python.org/packages/0c/4e/1ea357e7783c756bb579333c1e4a026fb331371ee771f616ffedc781e531
PYTHON_ENUM_SETUP_TYPE = setuptools
PYTHON_ENUM_LICENSE = GPL-3.0+
PYTHON_ENUM_LICENSE_FILES = LICENSE.GPL-3

$(eval $(python-package))
