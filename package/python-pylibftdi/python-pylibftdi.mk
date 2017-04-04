################################################################################
#
# python-pylibftdi
#
################################################################################

PYTHON_PYLIBFTDI_VERSION = 0.15.0
PYTHON_PYLIBFTDI_SOURCE = pylibftdi-$(PYTHON_PYLIBFTDI_VERSION).tar.gz
PYTHON_PYLIBFTDI_SITE = https://pypi.python.org/packages/e5/bb/d7a86dbd7685e3866ea75d21c6c726d01706fdc0aa5dc9051ce18ae65693
PYTHON_PYLIBFTDI_LICENSE = MIT
PYTHON_PYLIBFTDI_LICENSE_FILES = LICENSE.txt
PYTHON_PYLIBFTDI_DEPENDENCIES = libftdi
PYTHON_PYLIBFTDI_SETUP_TYPE = setuptools

$(eval $(python-package))
