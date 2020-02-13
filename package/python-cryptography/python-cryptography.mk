################################################################################
#
# python-cryptography
#
################################################################################

PYTHON_CRYPTOGRAPHY_VERSION = 2.8
PYTHON_CRYPTOGRAPHY_SOURCE = cryptography-$(PYTHON_CRYPTOGRAPHY_VERSION).tar.gz
PYTHON_CRYPTOGRAPHY_SITE = https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4
PYTHON_CRYPTOGRAPHY_SETUP_TYPE = setuptools
PYTHON_CRYPTOGRAPHY_LICENSE = Apache-2.0 or BSD-3-Clause
PYTHON_CRYPTOGRAPHY_LICENSE_FILES = LICENSE LICENSE.APACHE LICENSE.BSD
PYTHON_CRYPTOGRAPHY_DEPENDENCIES = host-python-cffi openssl
PYTHON_CRYPTOGRAPHY_ENV = CFLAGS="$(TARGET_CFLAGS) -pthread"

$(eval $(python-package))
