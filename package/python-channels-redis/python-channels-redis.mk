################################################################################
#
# python-channels-redis
#
################################################################################

PYTHON_CHANNELS_REDIS_VERSION = 2.4.0
PYTHON_CHANNELS_REDIS_SOURCE = channels_redis-$(PYTHON_CHANNELS_REDIS_VERSION).tar.gz
PYTHON_CHANNELS_REDIS_SITE = https://files.pythonhosted.org/packages/79/20/896a5246ef703a74dd0af6e46038eb7838d801e532cf25474d2580f09d3e
PYTHON_CHANNELS_REDIS_SETUP_TYPE = setuptools
PYTHON_CHANNELS_REDIS_LICENSE = BSD-3-Clause
PYTHON_CHANNELS_REDIS_LICENSE_FILES = LICENSE

$(eval $(python-package))
