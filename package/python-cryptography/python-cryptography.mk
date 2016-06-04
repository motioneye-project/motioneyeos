################################################################################
#
# python-cryptography
#
################################################################################

PYTHON_CRYPTOGRAPHY_VERSION = 1.3.4
PYTHON_CRYPTOGRAPHY_SOURCE = cryptography-$(PYTHON_CRYPTOGRAPHY_VERSION).tar.gz
PYTHON_CRYPTOGRAPHY_SITE = https://pypi.python.org/packages/f8/70/d7bd5c9c764732d5876ad34293e1ca55b2305a73ae6fcf1312202d1a798e
PYTHON_CRYPTOGRAPHY_SETUP_TYPE = setuptools
PYTHON_CRYPTOGRAPHY_LICENSE = Apache-2.0 or BSD-3c
PYTHON_CRYPTOGRAPHY_LICENSE_FILES = LICENSE LICENSE.APACHE LICENSE.BSD
PYTHON_CRYPTOGRAPHY_DEPENDENCIES = host-python-cffi openssl

$(eval $(python-package))
