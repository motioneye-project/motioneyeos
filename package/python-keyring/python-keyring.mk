################################################################################
#
# python-keyring
#
################################################################################

PYTHON_KEYRING_VERSION = 10.5.0
PYTHON_KEYRING_SOURCE = keyring-$(PYTHON_KEYRING_VERSION).tar.gz
PYTHON_KEYRING_SETUP_TYPE = setuptools
PYTHON_KEYRING_LICENSE = MIT
PYTHON_KEYRING_LICENSE_FILES = LICENSE
PYTHON_KEYRING_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
