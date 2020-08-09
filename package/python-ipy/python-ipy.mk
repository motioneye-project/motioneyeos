################################################################################
#
# python-ipy
#
################################################################################

PYTHON_IPY_VERSION = 1.00
PYTHON_IPY_SOURCE = IPy-$(PYTHON_IPY_VERSION).tar.gz
PYTHON_IPY_SITE = https://files.pythonhosted.org/packages/e1/66/b6dd22472bb027556849876beae2dd4dca3a4eaf2dd3039277b4edb8c6af
PYTHON_IPY_LICENSE = BSD-3-Clause
PYTHON_IPY_LICENSE_FILES = COPYING
PYTHON_IPY_SETUP_TYPE = distutils

$(eval $(python-package))
