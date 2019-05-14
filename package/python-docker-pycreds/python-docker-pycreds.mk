################################################################################
#
# python-docker-pycreds
#
################################################################################

PYTHON_DOCKER_PYCREDS_VERSION = 0.4.0
PYTHON_DOCKER_PYCREDS_SOURCE = docker-pycreds-$(PYTHON_DOCKER_PYCREDS_VERSION).tar.gz
PYTHON_DOCKER_PYCREDS_SITE = https://files.pythonhosted.org/packages/c5/e6/d1f6c00b7221e2d7c4b470132c931325c8b22c51ca62417e300f5ce16009
PYTHON_DOCKER_PYCREDS_SETUP_TYPE = setuptools
PYTHON_DOCKER_PYCREDS_LICENSE = Apache-2.0
PYTHON_DOCKER_PYCREDS_LICENSE_FILES = LICENSE

$(eval $(python-package))
