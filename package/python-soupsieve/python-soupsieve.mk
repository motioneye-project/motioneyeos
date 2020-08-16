################################################################################
#
# python-soupsieve
#
################################################################################

PYTHON_SOUPSIEVE_VERSION = 1.9.4
PYTHON_SOUPSIEVE_SOURCE = soupsieve-$(PYTHON_SOUPSIEVE_VERSION).tar.gz
PYTHON_SOUPSIEVE_SITE = https://files.pythonhosted.org/packages/7f/4e/95a13527e18b6f1a15c93f1c634b86d5fa634c5619dce695f4e0cd68182f
PYTHON_SOUPSIEVE_SETUP_TYPE = setuptools
PYTHON_SOUPSIEVE_LICENSE = MIT
PYTHON_SOUPSIEVE_LICENSE_FILES = LICENSE.md

$(eval $(python-package))
