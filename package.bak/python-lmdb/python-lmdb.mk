################################################################################
#
# python-lmdb
#
################################################################################

PYTHON_LMDB_VERSION = py-lmdb_0.89
PYTHON_LMDB_SITE = $(call github,dw,py-lmdb,$(PYTHON_LMDB_VERSION))
PYTHON_LMDB_LICENSE = OLDAP-2.8
PYTHON_LMDB_LICENSE_FILES = LICENSE
PYTHON_LMDB_SETUP_TYPE = setuptools
PYTHON_LMDB_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
