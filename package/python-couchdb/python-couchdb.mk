################################################################################
#
# python-couchdb
#
################################################################################

PYTHON_COUCHDB_VERSION = 1.2
PYTHON_COUCHDB_SOURCE = CouchDB-$(PYTHON_COUCHDB_VERSION).tar.gz
PYTHON_COUCHDB_SITE = https://files.pythonhosted.org/packages/7c/c8/f94a107eca0c178e5d74c705dad1a5205c0f580840bd1b155cd8a258cb7c
PYTHON_COUCHDB_SETUP_TYPE = setuptools
PYTHON_COUCHDB_LICENSE = BSD-3-Clause
PYTHON_COUCHDB_LICENSE_FILES = COPYING

$(eval $(python-package))
