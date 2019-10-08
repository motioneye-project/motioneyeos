################################################################################
#
# python-asn1crypto
#
################################################################################

PYTHON_ASN1CRYPTO_VERSION = 1.0.1
PYTHON_ASN1CRYPTO_SOURCE = asn1crypto-$(PYTHON_ASN1CRYPTO_VERSION).tar.gz
PYTHON_ASN1CRYPTO_SITE = https://files.pythonhosted.org/packages/d1/e2/c518f2bc5805668803ebf0659628b0e9d77ca981308c7e9e5564b30b8337
PYTHON_ASN1CRYPTO_SETUP_TYPE = setuptools
PYTHON_ASN1CRYPTO_LICENSE = MIT
PYTHON_ASN1CRYPTO_LICENSE_FILES = LICENSE

$(eval $(python-package))
