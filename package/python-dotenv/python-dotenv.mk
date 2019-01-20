################################################################################
#
# python-dotenv
#
################################################################################

PYTHON_DOTENV_VERSION = 0.10.1
PYTHON_DOTENV_SOURCE = python-dotenv-$(PYTHON_DOTENV_VERSION).tar.gz
PYTHON_DOTENV_SITE = https://files.pythonhosted.org/packages/0f/fe/b0e23db9c6b7dc8c2b21b62990890c85441c95557be1f3f3d5a126ec3009
PYTHON_DOTENV_SETUP_TYPE = setuptools
PYTHON_DOTENV_LICENSE = Apache-2.0
PYTHON_DOTENV_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
