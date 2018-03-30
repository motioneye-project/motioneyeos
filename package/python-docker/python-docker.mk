################################################################################
#
# python-docker
#
################################################################################

PYTHON_DOCKER_VERSION = 3.1.4
PYTHON_DOCKER_SOURCE = docker-$(PYTHON_DOCKER_VERSION).tar.gz
PYTHON_DOCKER_SITE = https://pypi.python.org/packages/7f/22/fd6e97c99a512f74d46dab2b450fe370eb2f83404ef790298e3fd012cd5c
PYTHON_DOCKER_SETUP_TYPE = setuptools
PYTHON_DOCKER_LICENSE = Apache-2.0
PYTHON_DOCKER_LICENSE_FILES = LICENSE

$(eval $(python-package))
