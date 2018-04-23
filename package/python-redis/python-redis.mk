################################################################################
#
# python-redis
#
################################################################################

PYTHON_REDIS_VERSION = 2.10.6
PYTHON_REDIS_SOURCE = redis-$(PYTHON_REDIS_VERSION).tar.gz
PYTHON_REDIS_SITE = https://pypi.python.org/packages/09/8d/6d34b75326bf96d4139a2ddd8e74b80840f800a0a79f9294399e212cb9a7
PYTHON_REDIS_SETUP_TYPE = setuptools

$(eval $(python-package))

