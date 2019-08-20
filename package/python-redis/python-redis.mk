################################################################################
#
# python-redis
#
################################################################################

PYTHON_REDIS_VERSION = 3.3.8
PYTHON_REDIS_SOURCE = redis-$(PYTHON_REDIS_VERSION).tar.gz
PYTHON_REDIS_SITE = https://files.pythonhosted.org/packages/d7/e9/549305f1c2480f8c24abadfaa71c20967cc3269769073b59960e9a566072
PYTHON_REDIS_SETUP_TYPE = setuptools
PYTHON_REDIS_LICENSE = MIT
PYTHON_REDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
