################################################################################
#
# python-pyparsing
#
################################################################################

PYTHON_PYPARSING_VERSION = 2.4.2
PYTHON_PYPARSING_SOURCE = pyparsing-$(PYTHON_PYPARSING_VERSION).tar.gz
PYTHON_PYPARSING_SITE = https://files.pythonhosted.org/packages/7e/24/eaa8d7003aee23eda270099eeec754d7bf4399f75c6a011ef948304f66a2
PYTHON_PYPARSING_LICENSE = MIT
PYTHON_PYPARSING_LICENSE_FILES = LICENSE
PYTHON_PYPARSING_SETUP_TYPE = setuptools

$(eval $(python-package))
