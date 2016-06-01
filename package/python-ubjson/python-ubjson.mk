################################################################################
#
# python-ubjson
#
################################################################################

PYTHON_UBJSON_VERSION = 0.8.4
PYTHON_UBJSON_SOURCE = py-ubjson-$(PYTHON_UBJSON_VERSION).tar.gz
PYTHON_UBJSON_SITE = https://pypi.python.org/packages/bf/a3/990c47fa0d2d244a3d493ae917d5cbf2a0632c1ac6aa53445f4e53ce3675
PYTHON_UBJSON_LICENSE = Apache-2.0
PYTHON_UBJSON_LICENSE_FILES = LICENSE
PYTHON_UBJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
