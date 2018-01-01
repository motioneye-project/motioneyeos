################################################################################
#
# python-decorator
#
################################################################################

PYTHON_DECORATOR_VERSION = 4.0.11
PYTHON_DECORATOR_SITE = https://pypi.python.org/packages/cc/ac/5a16f1fc0506ff72fcc8fd4e858e3a1c231f224ab79bb7c4c9b2094cc570
PYTHON_DECORATOR_SOURCE = decorator-$(PYTHON_DECORATOR_VERSION).tar.gz
PYTHON_DECORATOR_LICENSE = BSD-2-Clause
PYTHON_DECORATOR_SETUP_TYPE = setuptools

$(eval $(python-package))
