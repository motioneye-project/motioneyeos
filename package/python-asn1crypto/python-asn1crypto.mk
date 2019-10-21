################################################################################
#
# python-asn1crypto
#
################################################################################

PYTHON_ASN1CRYPTO_VERSION = 1.2.0
PYTHON_ASN1CRYPTO_SOURCE = asn1crypto-$(PYTHON_ASN1CRYPTO_VERSION).tar.gz
PYTHON_ASN1CRYPTO_SITE = https://files.pythonhosted.org/packages/c1/a9/86bfedaf41ca590747b4c9075bc470d0b2ec44fb5db5d378bc61447b3b6b
PYTHON_ASN1CRYPTO_SETUP_TYPE = setuptools
PYTHON_ASN1CRYPTO_LICENSE = MIT
PYTHON_ASN1CRYPTO_LICENSE_FILES = LICENSE

$(eval $(python-package))
