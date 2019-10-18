################################################################################
#
# python-secretstorage
#
################################################################################

PYTHON_SECRETSTORAGE_VERSION = 3.1.1
PYTHON_SECRETSTORAGE_SOURCE = SecretStorage-$(PYTHON_SECRETSTORAGE_VERSION).tar.gz
PYTHON_SECRETSTORAGE_SITE = https://files.pythonhosted.org/packages/a6/89/df343dbc2957a317127e7ff2983230dc5336273be34f2e1911519d85aeb5
PYTHON_SECRETSTORAGE_SETUP_TYPE = setuptools
PYTHON_SECRETSTORAGE_LICENSE = BSD-3-Clause
PYTHON_SECRETSTORAGE_LICENSE_FILES = LICENSE

$(eval $(python-package))
