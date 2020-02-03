################################################################################
#
# python-redis
#
################################################################################

PYTHON_REDIS_VERSION = 3.4.1
PYTHON_REDIS_SOURCE = redis-$(PYTHON_REDIS_VERSION).tar.gz
PYTHON_REDIS_SITE = https://files.pythonhosted.org/packages/ef/2e/2c0f59891db7db087a7eeaa79bc7c7f2c039e71a2b5b0a41391e9d462926
PYTHON_REDIS_SETUP_TYPE = setuptools
PYTHON_REDIS_LICENSE = MIT
PYTHON_REDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
