################################################################################
#
# python-docker-pycreds
#
################################################################################

PYTHON_DOCKER_PYCREDS_VERSION = 0.2.2
PYTHON_DOCKER_PYCREDS_SOURCE = docker-pycreds-$(PYTHON_DOCKER_PYCREDS_VERSION).tar.gz
PYTHON_DOCKER_PYCREDS_SITE = https://pypi.python.org/packages/db/73/42d4c698e70633d99f7f7c4c87c6de45ead5ad7b36dcfccd998fd1556ac9
PYTHON_DOCKER_PYCREDS_SETUP_TYPE = setuptools
PYTHON_DOCKER_PYCREDS_LICENSE = Apache-2.0
PYTHON_DOCKER_PYCREDS_LICENSE_FILES = LICENSE

$(eval $(python-package))
