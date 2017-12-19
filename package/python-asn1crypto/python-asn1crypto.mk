################################################################################
#
# python-asn1crypto
#
################################################################################

PYTHON_ASN1CRYPTO_VERSION = 0.22.0
PYTHON_ASN1CRYPTO_SOURCE = asn1crypto-$(PYTHON_ASN1CRYPTO_VERSION).tar.gz
PYTHON_ASN1CRYPTO_SITE = https://pypi.python.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6
PYTHON_ASN1CRYPTO_SETUP_TYPE = setuptools
PYTHON_ASN1CRYPTO_LICENSE = MIT

$(eval $(python-package))
