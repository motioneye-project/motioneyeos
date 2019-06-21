################################################################################
#
# python-pycairo
#
################################################################################

PYTHON_PYCAIRO_VERSION = 1.18.1
PYTHON_PYCAIRO_SOURCE = pycairo-$(PYTHON_PYCAIRO_VERSION).tar.gz
PYTHON_PYCAIRO_SITE = https://files.pythonhosted.org/packages/48/20/5e83af98eb897935bf7dc39455e892ba866feebb9b7c3b392982866f9958
PYTHON_PYCAIRO_SETUP_TYPE = setuptools
PYTHON_PYCAIRO_DEPENDENCIES = cairo
PYTHON_PYCAIRO_LICENSE = LGPL-2.1 or MPL-1.1
PYTHON_PYCAIRO_LICENSE_FILES = COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1

$(eval $(python-package))
