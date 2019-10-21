################################################################################
#
# python-docker
#
################################################################################

PYTHON_DOCKER_VERSION = 4.1.0
PYTHON_DOCKER_SOURCE = docker-$(PYTHON_DOCKER_VERSION).tar.gz
PYTHON_DOCKER_SITE = https://files.pythonhosted.org/packages/de/54/a822d7116ff2f726f3da2b3e6c87659657bdcb7a36e382860ed505ed5e45
PYTHON_DOCKER_SETUP_TYPE = setuptools
PYTHON_DOCKER_LICENSE = Apache-2.0
PYTHON_DOCKER_LICENSE_FILES = LICENSE

$(eval $(python-package))
