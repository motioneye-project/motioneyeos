################################################################################
#
# python-ubjson
#
################################################################################

PYTHON_UBJSON_VERSION = 0.8.5
PYTHON_UBJSON_SOURCE = py-ubjson-$(PYTHON_UBJSON_VERSION).tar.gz
PYTHON_UBJSON_SITE = https://pypi.python.org/packages/99/12/173cd417cacdacd158f947365bb17952a93b4e9d08f8a2f4b77d6c17cb4e
PYTHON_UBJSON_LICENSE = Apache-2.0
PYTHON_UBJSON_LICENSE_FILES = LICENSE
PYTHON_UBJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
