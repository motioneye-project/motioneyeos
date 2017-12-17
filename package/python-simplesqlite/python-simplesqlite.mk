################################################################################
#
# python-simplesqlite
#
################################################################################

PYTHON_SIMPLESQLITE_VERSION = 0.15.0
PYTHON_SIMPLESQLITE_SOURCE = SimpleSQLite-$(PYTHON_SIMPLESQLITE_VERSION).tar.gz
PYTHON_SIMPLESQLITE_SITE = https://pypi.python.org/packages/d5/09/e256a7d421c223505d4e89079b4936c6a6de39a5a095ec4bcaa9bfc3f933
PYTHON_SIMPLESQLITE_SETUP_TYPE = setuptools
PYTHON_SIMPLESQLITE_LICENSE = MIT
PYTHON_SIMPLESQLITE_LICENSE_FILES = LICENSE

$(eval $(python-package))
