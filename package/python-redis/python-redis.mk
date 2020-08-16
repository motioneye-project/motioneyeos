################################################################################
#
# python-redis
#
################################################################################

PYTHON_REDIS_VERSION = 3.5.0
PYTHON_REDIS_SOURCE = redis-$(PYTHON_REDIS_VERSION).tar.gz
PYTHON_REDIS_SITE = https://files.pythonhosted.org/packages/05/5e/5e9a329ba600244f2d37f86131ccec19936d41cba0887240086b44cf4f54
PYTHON_REDIS_SETUP_TYPE = setuptools
PYTHON_REDIS_LICENSE = MIT
PYTHON_REDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
