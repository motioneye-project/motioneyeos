################################################################################
#
# python-pycairo
#
################################################################################

PYTHON_PYCAIRO_VERSION = 1.19.1
PYTHON_PYCAIRO_SOURCE = pycairo-$(PYTHON_PYCAIRO_VERSION).tar.gz
PYTHON_PYCAIRO_SITE = https://files.pythonhosted.org/packages/e8/9d/c8be300fc6b1298559d37a071c3833b0b251e0fff334d2e4c408d5789162
PYTHON_PYCAIRO_SETUP_TYPE = setuptools
PYTHON_PYCAIRO_DEPENDENCIES = cairo
PYTHON_PYCAIRO_LICENSE = LGPL-2.1 or MPL-1.1
PYTHON_PYCAIRO_LICENSE_FILES = COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1

$(eval $(python-package))
