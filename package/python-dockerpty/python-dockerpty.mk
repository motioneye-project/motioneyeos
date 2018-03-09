################################################################################
#
# python-dockerpty
#
################################################################################

PYTHON_DOCKERPTY_VERSION = 0.4.1
PYTHON_DOCKERPTY_SOURCE = dockerpty-$(PYTHON_DOCKERPTY_VERSION).tar.gz
PYTHON_DOCKERPTY_SITE = https://pypi.python.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba
PYTHON_DOCKERPTY_SETUP_TYPE = setuptools
PYTHON_DOCKERPTY_LICENSE = Apache-2.0
PYTHON_DOCKERPTY_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
