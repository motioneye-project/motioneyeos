################################################################################
#
# python-keyring
#
################################################################################

PYTHON_KEYRING_VERSION = 10.5.0
PYTHON_KEYRING_SOURCE = keyring-$(PYTHON_KEYRING_VERSION).tar.gz
PYTHON_KEYRING_SITE = https://pypi.python.org/packages/42/2e/51bd1739fe335095a2174db3f2f230346762e7e572471059540146a521f6
PYTHON_KEYRING_SETUP_TYPE = setuptools
PYTHON_KEYRING_LICENSE = MIT
PYTHON_KEYRING_LICENSE_FILES = LICENSE
PYTHON_KEYRING_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
