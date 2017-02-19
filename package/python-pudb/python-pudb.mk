################################################################################
#
# python-pudb
#
################################################################################

PYTHON_PUDB_VERSION = 2017.1.1
PYTHON_PUDB_SOURCE = pudb-$(PYTHON_PUDB_VERSION).tar.gz
PYTHON_PUDB_SITE = https://pypi.python.org/packages/3f/ab/a8e103f329460696bb74e3c5cef4060313be3fe0f6fceae866900cb2033c
PYTHON_PUDB_SETUP_TYPE = setuptools
PYTHON_PUDB_LICENSE = MIT
PYTHON_PUDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
