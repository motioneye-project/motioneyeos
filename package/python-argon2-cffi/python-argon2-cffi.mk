################################################################################
#
# python-argon2-cffi
#
################################################################################

PYTHON_ARGON2_CFFI_VERSION = 19.2.0
PYTHON_ARGON2_CFFI_SOURCE = argon2-cffi-$(PYTHON_ARGON2_CFFI_VERSION).tar.gz
PYTHON_ARGON2_CFFI_SITE = https://files.pythonhosted.org/packages/e4/96/f1bf2369f29794971f836b8eff5e3bdb653043f1b61d104eae21b1de3ccb
PYTHON_ARGON2_CFFI_SETUP_TYPE = setuptools
PYTHON_ARGON2_CFFI_LICENSE = MIT
PYTHON_ARGON2_CFFI_LICENSE_FILES = LICENSE
PYTHON_ARGON2_CFFI_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
