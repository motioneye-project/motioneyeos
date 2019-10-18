################################################################################
#
# python-redis
#
################################################################################

PYTHON_REDIS_VERSION = 3.3.11
PYTHON_REDIS_SOURCE = redis-$(PYTHON_REDIS_VERSION).tar.gz
PYTHON_REDIS_SITE = https://files.pythonhosted.org/packages/06/ca/00557c74279d2f256d3c42cabf237631355f3a132e4c74c2000e6647ad98
PYTHON_REDIS_SETUP_TYPE = setuptools
PYTHON_REDIS_LICENSE = MIT
PYTHON_REDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
