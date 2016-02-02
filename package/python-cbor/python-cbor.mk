################################################################################
#
# python-cbor
#
################################################################################

PYTHON_CBOR_VERSION = 0.1.25
PYTHON_CBOR_SOURCE = cbor-$(PYTHON_CBOR_VERSION).tar.gz
PYTHON_CBOR_SITE = http://pypi.python.org/packages/source/c/cbor
PYTHON_CBOR_LICENSE = Apache
PYTHON_CBOR_SETUP_TYPE = setuptools

$(eval $(python-package))
