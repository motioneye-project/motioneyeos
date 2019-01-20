################################################################################
#
# python-redis
#
################################################################################

PYTHON_REDIS_VERSION = 3.0.1
PYTHON_REDIS_SOURCE = redis-$(PYTHON_REDIS_VERSION).tar.gz
PYTHON_REDIS_SITE = https://files.pythonhosted.org/packages/4a/1b/9b40393630954b54a4182ca65a9cf80b41803108fcae435ffd6af57af5ae
PYTHON_REDIS_SETUP_TYPE = setuptools
PYTHON_REDIS_LICENSE = Apache-2.0
PYTHON_REDIS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
