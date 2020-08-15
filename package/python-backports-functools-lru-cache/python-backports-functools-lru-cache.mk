################################################################################
#
# python-backports-functools-lru-cache
#
################################################################################

PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_VERSION = 1.5
PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_SOURCE = backports.functools_lru_cache-$(PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_VERSION).tar.gz
PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_SITE = https://files.pythonhosted.org/packages/57/d4/156eb5fbb08d2e85ab0a632e2bebdad355798dece07d4752f66a8d02d1ea
PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_SETUP_TYPE = setuptools
PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_DEPENDENCIES = host-python-setuptools-scm
PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_LICENSE = MIT
PYTHON_BACKPORTS_FUNCTOOLS_LRU_CACHE_LICENSE_FILES = LICENSE

$(eval $(python-package))
