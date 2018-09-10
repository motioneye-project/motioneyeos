################################################################################
#
# python-asn1crypto
#
################################################################################

PYTHON_ASN1CRYPTO_VERSION = 0.24.0
PYTHON_ASN1CRYPTO_SOURCE = asn1crypto-$(PYTHON_ASN1CRYPTO_VERSION).tar.gz
PYTHON_ASN1CRYPTO_SITE = https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4
PYTHON_ASN1CRYPTO_SETUP_TYPE = setuptools
PYTHON_ASN1CRYPTO_LICENSE = MIT
PYTHON_ASN1CRYPTO_LICENSE_FILES = LICENSE

$(eval $(python-package))
