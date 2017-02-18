################################################################################
#
# python-cbor
#
################################################################################

PYTHON_CBOR_VERSION = 1.0.0
PYTHON_CBOR_SOURCE = cbor-$(PYTHON_CBOR_VERSION).tar.gz
PYTHON_CBOR_SITE = https://pypi.python.org/packages/9b/99/01c6a987c920500189eb74a291bd3a388e6c7cf85736bb6b066d9833315e
PYTHON_CBOR_LICENSE = Apache
PYTHON_CBOR_SETUP_TYPE = setuptools

$(eval $(python-package))
