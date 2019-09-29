################################################################################
#
# python-lmdb
#
################################################################################

PYTHON_LMDB_VERSION = 0.94
PYTHON_LMDB_SOURCE = lmdb-$(PYTHON_LMDB_VERSION).tar.gz
PYTHON_LMDB_SITE = https://files.pythonhosted.org/packages/cb/31/5be8f436b56733d9e69c721c358502f4d77b627489a459978686be7db65f
PYTHON_LMDB_LICENSE = OLDAP-2.8
PYTHON_LMDB_LICENSE_FILES = LICENSE
PYTHON_LMDB_SETUP_TYPE = setuptools
PYTHON_LMDB_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
