################################################################################
#
# python-bluezero
#
################################################################################

PYTHON_BLUEZERO_VERSION = 0.3.0
PYTHON_BLUEZERO_SOURCE = bluezero-$(PYTHON_BLUEZERO_VERSION).tar.gz
PYTHON_BLUEZERO_SITE = https://files.pythonhosted.org/packages/e4/d8/c5451133c0773a0378cadb6c014d7f03b5786da1d39af2f9eaa8028e6662
PYTHON_BLUEZERO_SETUP_TYPE = setuptools
PYTHON_BLUEZERO_LICENSE = MIT

$(eval $(python-package))
