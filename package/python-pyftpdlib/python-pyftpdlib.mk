################################################################################
#
# python-pyftpdlib
#
################################################################################

PYTHON_PYFTPDLIB_VERSION = 1.5.0
PYTHON_PYFTPDLIB_SOURCE = pyftpdlib-$(PYTHON_PYFTPDLIB_VERSION).tar.gz
PYTHON_PYFTPDLIB_SITE = https://pypi.python.org/packages/source/p/pyftpdlib
PYTHON_PYFTPDLIB_SETUP_TYPE = setuptools
PYTHON_PYFTPDLIB_LICENSE = MIT
PYTHON_PYFTPDLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
