################################################################################
#
# docker-compose
#
################################################################################

DOCKER_COMPOSE_VERSION = 1.24.1
DOCKER_COMPOSE_SITE = https://files.pythonhosted.org/packages/b6/a4/59c39df6a23144a6252ad33170dfbf781af5953651e4587e8ea5f995f95e
DOCKER_COMPOSE_SETUP_TYPE = setuptools
DOCKER_COMPOSE_LICENSE = Apache-2.0
DOCKER_COMPOSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
