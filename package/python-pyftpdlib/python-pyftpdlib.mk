################################################################################
#
# python-pyftpdlib
#
################################################################################

PYTHON_PYFTPDLIB_VERSION = 1.5.3
PYTHON_PYFTPDLIB_SOURCE = pyftpdlib-$(PYTHON_PYFTPDLIB_VERSION).tar.gz
PYTHON_PYFTPDLIB_SITE = https://pypi.python.org/packages/c5/fb/74f6425fbb7f2a87969e1aa01bb9684601de431a3488b95f64509bf985ef
PYTHON_PYFTPDLIB_SETUP_TYPE = setuptools
PYTHON_PYFTPDLIB_LICENSE = MIT
PYTHON_PYFTPDLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
