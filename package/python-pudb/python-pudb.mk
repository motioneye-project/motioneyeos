################################################################################
#
# python-pudb
#
################################################################################

PYTHON_PUDB_VERSION = 2019.1
PYTHON_PUDB_SOURCE = pudb-$(PYTHON_PUDB_VERSION).tar.gz
PYTHON_PUDB_SITE = https://files.pythonhosted.org/packages/32/2a/96f72649e5dfc90cf69d8590c00884c6897d6cbc54f727fb40f47b4faae3
PYTHON_PUDB_SETUP_TYPE = setuptools
PYTHON_PUDB_LICENSE = MIT
PYTHON_PUDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
