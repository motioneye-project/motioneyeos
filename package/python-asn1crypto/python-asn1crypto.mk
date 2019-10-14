################################################################################
#
# python-asn1crypto
#
################################################################################

PYTHON_ASN1CRYPTO_VERSION = 1.1.0
PYTHON_ASN1CRYPTO_SOURCE = asn1crypto-$(PYTHON_ASN1CRYPTO_VERSION).tar.gz
PYTHON_ASN1CRYPTO_SITE = https://files.pythonhosted.org/packages/04/20/ac105ae01c29580ebff75bbf1effb69d788bfa54a8336a8f14399b09e2e1
PYTHON_ASN1CRYPTO_SETUP_TYPE = setuptools
PYTHON_ASN1CRYPTO_LICENSE = MIT
PYTHON_ASN1CRYPTO_LICENSE_FILES = LICENSE

$(eval $(python-package))
