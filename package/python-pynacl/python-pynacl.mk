################################################################################
#
# python-pynacl
#
################################################################################

PYTHON_PYNACL_VERSION = 1.0.1
PYTHON_PYNACL_SOURCE = PyNaCl-$(PYTHON_PYNACL_VERSION).tar.gz
PYTHON_PYNACL_SITE = https://pypi.python.org/packages/source/P/PyNaCl
PYTHON_PYNACL_LICENSE = Apache-2.0
PYTHON_PYNACL_LICENSE_FILES = LICENSE
PYTHON_PYNACL_SETUP_TYPE = setuptools
PYTHON_PYNACL_DEPENDENCIES = libsodium host-python-cffi
PYTHON_PYNACL_ENV = SODIUM_INSTALL=system

$(eval $(python-package))
