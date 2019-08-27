################################################################################
#
# python-pantilthat
#
################################################################################

PYTHON_PANTILTHAT_VERSION = 0.0.7
PYTHON_PANTILTHAT_SOURCE = pantilthat-$(PYTHON_PANTILTHAT_VERSION).tar.gz
PYTHON_PANTILTHAT_SITE = https://files.pythonhosted.org/packages/c7/e1/3d5403cf568b5232ca04d8c90e82af4486f1a2f34e1ce82babab40820b0e
PYTHON_PANTILTHAT_SETUP_TYPE = setuptools
PYTHON_PANTILTHAT_LICENSE = MIT

$(eval $(python-package))
