################################################################################
#
# python-pylibftdi
#
################################################################################

PYTHON_PYLIBFTDI_VERSION = 0.18.0
PYTHON_PYLIBFTDI_SOURCE = pylibftdi-$(PYTHON_PYLIBFTDI_VERSION).tar.gz
PYTHON_PYLIBFTDI_SITE = https://files.pythonhosted.org/packages/e6/2c/22d38c873f7c83a7b48df25744763d94e638ba2ee158d40a176748e21b60
PYTHON_PYLIBFTDI_LICENSE = MIT
PYTHON_PYLIBFTDI_LICENSE_FILES = LICENSE.txt
PYTHON_PYLIBFTDI_DEPENDENCIES = libftdi
PYTHON_PYLIBFTDI_SETUP_TYPE = setuptools

$(eval $(python-package))
