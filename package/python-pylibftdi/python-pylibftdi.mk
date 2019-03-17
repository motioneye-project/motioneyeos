################################################################################
#
# python-pylibftdi
#
################################################################################

PYTHON_PYLIBFTDI_VERSION = 0.17.0
PYTHON_PYLIBFTDI_SOURCE = pylibftdi-$(PYTHON_PYLIBFTDI_VERSION).tar.gz
PYTHON_PYLIBFTDI_SITE = https://pypi.python.org/packages/33/30/88b80d63ad3dae29972490ed7b16d7a9ef5f70bd35748ce3ee982bf42c41
PYTHON_PYLIBFTDI_LICENSE = MIT
PYTHON_PYLIBFTDI_LICENSE_FILES = LICENSE.txt
PYTHON_PYLIBFTDI_DEPENDENCIES = libftdi
PYTHON_PYLIBFTDI_SETUP_TYPE = setuptools

$(eval $(python-package))
