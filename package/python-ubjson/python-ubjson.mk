################################################################################
#
# python-ubjson
#
################################################################################

PYTHON_UBJSON_VERSION = 0.9.0
PYTHON_UBJSON_SOURCE = py-ubjson-$(PYTHON_UBJSON_VERSION).tar.gz
PYTHON_UBJSON_SITE = https://pypi.python.org/packages/d4/40/a80006884ec03a54a5c6c53ae76df9978536862f0683b6e6280e3808d289
PYTHON_UBJSON_LICENSE = Apache-2.0
PYTHON_UBJSON_LICENSE_FILES = LICENSE
PYTHON_UBJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
