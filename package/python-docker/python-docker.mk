################################################################################
#
# python-docker
#
################################################################################

PYTHON_DOCKER_VERSION = 3.1.1
PYTHON_DOCKER_SOURCE = docker-$(PYTHON_DOCKER_VERSION).tar.gz
PYTHON_DOCKER_SITE = https://pypi.python.org/packages/0d/17/ad98e025e5528337c4dc5835a5874898eb226da17e4ffed732c894cb1938
PYTHON_DOCKER_SETUP_TYPE = setuptools
PYTHON_DOCKER_LICENSE = Apache-2.0
PYTHON_DOCKER_LICENSE_FILES = LICENSE

$(eval $(python-package))
