################################################################################
#
# python-pycairo
#
################################################################################

PYTHON_PYCAIRO_VERSION = 1.18.2
PYTHON_PYCAIRO_SOURCE = pycairo-$(PYTHON_PYCAIRO_VERSION).tar.gz
PYTHON_PYCAIRO_SITE = https://files.pythonhosted.org/packages/3c/1a/c0478ecab31baae50fda9956547788afbd0ca563adc52c9b03cab30f17eb
PYTHON_PYCAIRO_SETUP_TYPE = setuptools
PYTHON_PYCAIRO_DEPENDENCIES = cairo
PYTHON_PYCAIRO_LICENSE = LGPL-2.1 or MPL-1.1
PYTHON_PYCAIRO_LICENSE_FILES = COPYING COPYING-LGPL-2.1 COPYING-MPL-1.1

$(eval $(python-package))
