################################################################################
#
# python-docker
#
################################################################################

PYTHON_DOCKER_VERSION = 3.5.1
PYTHON_DOCKER_SOURCE = docker-$(PYTHON_DOCKER_VERSION).tar.gz
PYTHON_DOCKER_SITE = https://files.pythonhosted.org/packages/b1/4f/d4f646843335430701d459fea08b0285a2c0a364150dd5b9c5f27f723121
PYTHON_DOCKER_SETUP_TYPE = setuptools
PYTHON_DOCKER_LICENSE = Apache-2.0
PYTHON_DOCKER_LICENSE_FILES = LICENSE

$(eval $(python-package))
