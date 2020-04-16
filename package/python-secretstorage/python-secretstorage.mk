################################################################################
#
# python-secretstorage
#
################################################################################

PYTHON_SECRETSTORAGE_VERSION = 3.1.2
PYTHON_SECRETSTORAGE_SOURCE = SecretStorage-$(PYTHON_SECRETSTORAGE_VERSION).tar.gz
PYTHON_SECRETSTORAGE_SITE = https://files.pythonhosted.org/packages/fd/9f/36197c75d9a09b1ab63f56cb985af6cd858ca3fc41fd9cd890ce69bae5b9
PYTHON_SECRETSTORAGE_SETUP_TYPE = setuptools
PYTHON_SECRETSTORAGE_LICENSE = BSD-3-Clause
PYTHON_SECRETSTORAGE_LICENSE_FILES = LICENSE

$(eval $(python-package))
