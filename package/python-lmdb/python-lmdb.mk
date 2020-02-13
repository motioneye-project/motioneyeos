################################################################################
#
# python-lmdb
#
################################################################################

PYTHON_LMDB_VERSION = 0.98
PYTHON_LMDB_SOURCE = lmdb-$(PYTHON_LMDB_VERSION).tar.gz
PYTHON_LMDB_SITE = https://files.pythonhosted.org/packages/c0/5c/d56dbc2532ecf14fa004c543927500c0f645eaca8bd7ec39420c7546396a
PYTHON_LMDB_LICENSE = OLDAP-2.8
PYTHON_LMDB_LICENSE_FILES = LICENSE
PYTHON_LMDB_SETUP_TYPE = setuptools
PYTHON_LMDB_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
