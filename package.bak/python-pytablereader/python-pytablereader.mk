################################################################################
#
# python-pytablereader
#
################################################################################

PYTHON_PYTABLEREADER_VERSION = 0.8.8
PYTHON_PYTABLEREADER_SOURCE = pytablereader-$(PYTHON_PYTABLEREADER_VERSION).tar.gz
PYTHON_PYTABLEREADER_SITE = https://pypi.python.org/packages/05/0c/7801617e60ce0d9b4cc57cb542cc431a95b9f43ac1ac14030017163da29d
PYTHON_PYTABLEREADER_SETUP_TYPE = setuptools
PYTHON_PYTABLEREADER_LICENSE = MIT
PYTHON_PYTABLEREADER_LICENSE_FILES = LICENSE

$(eval $(python-package))
