################################################################################
#
# python-crossbar
#
################################################################################

PYTHON_CROSSBAR_VERSION = 19.1.1
PYTHON_CROSSBAR_SOURCE = crossbar-$(PYTHON_CROSSBAR_VERSION).tar.gz
PYTHON_CROSSBAR_SITE = https://files.pythonhosted.org/packages/38/55/54ac74ca6b4a3b0fe5919fd7ee787c444ce79d8dca58d561ea3f8e185782
PYTHON_CROSSBAR_LICENSE = AGPL-3.0
PYTHON_CROSSBAR_LICENSE_FILES = LICENSE
PYTHON_CROSSBAR_SETUP_TYPE = setuptools

$(eval $(python-package))
