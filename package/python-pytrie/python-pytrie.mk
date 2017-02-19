################################################################################
#
# python-pytrie
#
################################################################################

PYTHON_PYTRIE_VERSION = 0.3
PYTHON_PYTRIE_SITE = https://pypi.python.org/packages/aa/4a/3a3e7e95cb6202192c268043bed586f299e5b72b2650ece4614f60aecf2b
PYTHON_PYTRIE_SOURCE = PyTrie-$(PYTHON_PYTRIE_VERSION).tar.gz
PYTHON_PYTRIE_LICENSE = BSD-3c
PYTHON_PYTRIE_LICENSE_FILES = LICENSE
PYTHON_PYTRIE_SETUP_TYPE = distutils

$(eval $(python-package))
