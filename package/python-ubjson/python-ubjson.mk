################################################################################
#
# python-ubjson
#
################################################################################

PYTHON_UBJSON_VERSION = 0.12.0
PYTHON_UBJSON_SOURCE = py-ubjson-$(PYTHON_UBJSON_VERSION).tar.gz
PYTHON_UBJSON_SITE = https://files.pythonhosted.org/packages/68/9c/a6c34e565351f0b04bcf6835e38bc4bd0647269dc48670e12eb99a3f5ef5
PYTHON_UBJSON_LICENSE = Apache-2.0
PYTHON_UBJSON_LICENSE_FILES = LICENSE
PYTHON_UBJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
