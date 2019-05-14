################################################################################
#
# python-dotenv
#
################################################################################

PYTHON_DOTENV_VERSION = 0.10.2
PYTHON_DOTENV_SOURCE = python-dotenv-$(PYTHON_DOTENV_VERSION).tar.gz
PYTHON_DOTENV_SITE = https://files.pythonhosted.org/packages/2d/f0/f89093378e5a7c028d7d618c9ce60a7853a1f36d46ff9e497ba03df102d5
PYTHON_DOTENV_SETUP_TYPE = setuptools
PYTHON_DOTENV_LICENSE = Apache-2.0
PYTHON_DOTENV_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
