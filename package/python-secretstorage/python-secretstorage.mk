################################################################################
#
# python-secretstorage
#
################################################################################

PYTHON_SECRETSTORAGE_VERSION = 2.3.1
PYTHON_SECRETSTORAGE_SOURCE = SecretStorage-$(PYTHON_SECRETSTORAGE_VERSION).tar.gz
PYTHON_SECRETSTORAGE_SITE = https://pypi.python.org/packages/a5/a5/0830cfe34a4cfd0d1c3c8b614ede1edb2aaf999091ac8548dd19cb352e79
PYTHON_SECRETSTORAGE_SETUP_TYPE = setuptools
PYTHON_SECRETSTORAGE_LICENSE = BSD-3-Clause
PYTHON_SECRETSTORAGE_LICENSE_FILES = LICENSE

$(eval $(python-package))
