################################################################################
#
# python-pynacl
#
################################################################################

PYTHON_PYNACL_VERSION = 1.2.1
PYTHON_PYNACL_SOURCE = PyNaCl-$(PYTHON_PYNACL_VERSION).tar.gz
PYTHON_PYNACL_SITE = https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f
PYTHON_PYNACL_LICENSE = Apache-2.0
PYTHON_PYNACL_LICENSE_FILES = LICENSE
PYTHON_PYNACL_SETUP_TYPE = setuptools
PYTHON_PYNACL_DEPENDENCIES = libsodium host-python-cffi
PYTHON_PYNACL_ENV = SODIUM_INSTALL=system

$(eval $(python-package))
