################################################################################
#
# python-cryptography
#
################################################################################

PYTHON_CRYPTOGRAPHY_VERSION = 1.5.2
PYTHON_CRYPTOGRAPHY_SOURCE = cryptography-$(PYTHON_CRYPTOGRAPHY_VERSION).tar.gz
PYTHON_CRYPTOGRAPHY_SITE = https://pypi.python.org/packages/03/1a/60984cb85cc38c4ebdfca27b32a6df6f1914959d8790f5a349608c78be61
PYTHON_CRYPTOGRAPHY_SETUP_TYPE = setuptools
PYTHON_CRYPTOGRAPHY_LICENSE = Apache-2.0 or BSD-3c
PYTHON_CRYPTOGRAPHY_LICENSE_FILES = LICENSE LICENSE.APACHE LICENSE.BSD
PYTHON_CRYPTOGRAPHY_DEPENDENCIES = host-python-cffi openssl

$(eval $(python-package))
