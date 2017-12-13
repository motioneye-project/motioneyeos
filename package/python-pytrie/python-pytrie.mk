################################################################################
#
# python-pytrie
#
################################################################################

PYTHON_PYTRIE_VERSION = 0.2
PYTHON_PYTRIE_SITE = https://pypi.python.org/packages/source/P/PyTrie
PYTHON_PYTRIE_SOURCE = PyTrie-$(PYTHON_PYTRIE_VERSION).tar.gz
PYTHON_PYTRIE_LICENSE = BSD-3-Clause
PYTHON_PYTRIE_LICENSE_FILES = LICENSE
PYTHON_PYTRIE_SETUP_TYPE = distutils

$(eval $(python-package))
