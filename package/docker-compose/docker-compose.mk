################################################################################
#
# docker-compose
#
################################################################################

DOCKER_COMPOSE_VERSION = 1.20.0rc1
DOCKER_COMPOSE_SITE = https://pypi.python.org/packages/ca/d9/21266285a3c34e8e023f2504c13ffb48e6acd1e43ccdd0c55188d7039505
DOCKER_COMPOSE_SETUP_TYPE = setuptools
DOCKER_COMPOSE_LICENSE = Apache-2.0
DOCKER_COMPOSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
