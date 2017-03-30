################################################################################
#
# python-enum34
#
################################################################################

PYTHON_ENUM34_VERSION = 1.1.6
PYTHON_ENUM34_SOURCE = enum34-$(PYTHON_ENUM34_VERSION).tar.gz
PYTHON_ENUM34_SITE = https://pypi.python.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876
PYTHON_ENUM34_SETUP_TYPE = distutils
PYTHON_ENUM34_LICENSE = BSD-3-Clause
PYTHON_ENUM34_LICENSE_FILES = enum/LICENSE

$(eval $(python-package))
