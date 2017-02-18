################################################################################
#
# python-cryptography
#
################################################################################

PYTHON_CRYPTOGRAPHY_VERSION = 1.3.1
PYTHON_CRYPTOGRAPHY_SOURCE = cryptography-$(PYTHON_CRYPTOGRAPHY_VERSION).tar.gz
PYTHON_CRYPTOGRAPHY_SITE = https://pypi.python.org/packages/source/c/cryptography
PYTHON_CRYPTOGRAPHY_SETUP_TYPE = setuptools
PYTHON_CRYPTOGRAPHY_LICENSE = Apache-2.0 or BSD-3c
PYTHON_CRYPTOGRAPHY_LICENSE_FILES = LICENSE LICENSE.APACHE LICENSE.BSD
PYTHON_CRYPTOGRAPHY_DEPENDENCIES = host-python-cffi openssl

$(eval $(python-package))
