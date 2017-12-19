################################################################################
#
# python-bcrypt
#
################################################################################

PYTHON_BCRYPT_VERSION = 3.1.3
PYTHON_BCRYPT_SOURCE = bcrypt-$(PYTHON_BCRYPT_VERSION).tar.gz
PYTHON_BCRYPT_SITE = https://pypi.python.org/packages/58/e9/6d7f1d883d8c5876470b5d187d72c04f2a9954d61e71e7eb5d2ea2a50442
PYTHON_BCRYPT_SETUP_TYPE = setuptools
PYTHON_BCRYPT_LICENSE = Apache-2.0
PYTHON_BCRYPT_LICENSE_FILES = LICENSE
PYTHON_BCRYPT_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
