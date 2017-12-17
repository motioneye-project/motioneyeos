################################################################################
#
# python-couchdb
#
################################################################################

PYTHON_COUCHDB_VERSION = 1.1
PYTHON_COUCHDB_SOURCE = CouchDB-$(PYTHON_COUCHDB_VERSION).tar.gz
PYTHON_COUCHDB_SITE = https://pypi.python.org/packages/9a/e8/c3c8da6d00145aaca07f2b784794917613dad26532068da4e8392dc48d7f
PYTHON_COUCHDB_SETUP_TYPE = setuptools
PYTHON_COUCHDB_LICENSE = BSD-3-Clause
PYTHON_COUCHDB_LICENSE_FILES = COPYING

$(eval $(python-package))
