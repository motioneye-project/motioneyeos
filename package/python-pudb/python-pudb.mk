################################################################################
#
# python-pudb
#
################################################################################

PYTHON_PUDB_VERSION = 2017.1.2
PYTHON_PUDB_SOURCE = pudb-$(PYTHON_PUDB_VERSION).tar.gz
PYTHON_PUDB_SITE = https://pypi.python.org/packages/d3/8a/e0fa18cf6f939a63364117546c9bd933add800642004ad40fd5f5bdba0c6
PYTHON_PUDB_SETUP_TYPE = setuptools
PYTHON_PUDB_LICENSE = MIT
PYTHON_PUDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
