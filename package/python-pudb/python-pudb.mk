################################################################################
#
# python-pudb
#
################################################################################

PYTHON_PUDB_VERSION = 2016.2
PYTHON_PUDB_SOURCE = pudb-$(PYTHON_PUDB_VERSION).tar.gz
PYTHON_PUDB_SITE = https://pypi.python.org/packages/50/1a/d9b692e32afff09ccb5aa33c3d51c6d5a80efbb59de90307b33601e7fa62
PYTHON_PUDB_SETUP_TYPE = setuptools
PYTHON_PUDB_LICENSE = MIT
PYTHON_PUDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
