################################################################################
#
# python-pylibftdi
#
################################################################################

PYTHON_PYLIBFTDI_VERSION = 0.18.1
PYTHON_PYLIBFTDI_SOURCE = pylibftdi-$(PYTHON_PYLIBFTDI_VERSION).tar.gz
PYTHON_PYLIBFTDI_SITE = https://files.pythonhosted.org/packages/50/9b/1e1cdb9715bacfb83e5eaf5e69f4e2fbd92d61f43c5e185cc3935ec01b28
PYTHON_PYLIBFTDI_LICENSE = MIT
PYTHON_PYLIBFTDI_LICENSE_FILES = LICENSE.txt
PYTHON_PYLIBFTDI_DEPENDENCIES = libftdi
PYTHON_PYLIBFTDI_SETUP_TYPE = setuptools

$(eval $(python-package))
