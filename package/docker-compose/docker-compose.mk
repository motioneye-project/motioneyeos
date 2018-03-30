################################################################################
#
# docker-compose
#
################################################################################

DOCKER_COMPOSE_VERSION = 1.20.1
DOCKER_COMPOSE_SITE = https://pypi.python.org/packages/25/4f/4e2b8ff942c9b3d96a81082590617c5c5fa006b066a4181b8d985ea3ac79
DOCKER_COMPOSE_SETUP_TYPE = setuptools
DOCKER_COMPOSE_LICENSE = Apache-2.0
DOCKER_COMPOSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
