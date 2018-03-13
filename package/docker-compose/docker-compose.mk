################################################################################
#
# docker-compose
#
################################################################################

DOCKER_COMPOSE_VERSION = 1.20.0rc2
DOCKER_COMPOSE_SITE = https://pypi.python.org/packages/b9/fe/44a2d249d86ef04ccf792c841fc73ffcf96e6138ca3a926de8ba032cf912
DOCKER_COMPOSE_SETUP_TYPE = setuptools
DOCKER_COMPOSE_LICENSE = Apache-2.0
DOCKER_COMPOSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
