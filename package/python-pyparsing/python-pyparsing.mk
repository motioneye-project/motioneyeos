################################################################################
#
# python-pyparsing
#
################################################################################

PYTHON_PYPARSING_VERSION = 2.0.3
PYTHON_PYPARSING_SOURCE = pyparsing-$(PYTHON_PYPARSING_VERSION).tar.gz
PYTHON_PYPARSING_SITE = https://pypi.python.org/packages/source/p/pyparsing
PYTHON_PYPARSING_LICENSE = MIT
PYTHON_PYPARSING_LICENSE_FILES = LICENSE
PYTHON_PYPARSING_SETUP_TYPE = distutils

$(eval $(python-package))
