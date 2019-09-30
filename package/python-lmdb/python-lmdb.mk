################################################################################
#
# python-lmdb
#
################################################################################

PYTHON_LMDB_VERSION = 0.97
PYTHON_LMDB_SOURCE = lmdb-$(PYTHON_LMDB_VERSION).tar.gz
PYTHON_LMDB_SITE = https://files.pythonhosted.org/packages/9f/8f/37cc080deb867305bf2d3ec4639e33b981d0def8d78949454a4654ca16bf
PYTHON_LMDB_LICENSE = OLDAP-2.8
PYTHON_LMDB_LICENSE_FILES = LICENSE
PYTHON_LMDB_SETUP_TYPE = setuptools
PYTHON_LMDB_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
