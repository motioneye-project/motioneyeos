################################################################################
#
# python-pytrie
#
################################################################################

PYTHON_PYTRIE_VERSION = 0.3.1
PYTHON_PYTRIE_SOURCE = PyTrie-$(PYTHON_PYTRIE_VERSION).tar.gz
PYTHON_PYTRIE_LICENSE = BSD-3-Clause
PYTHON_PYTRIE_LICENSE_FILES = PKG-INFO
PYTHON_PYTRIE_SITE = https://files.pythonhosted.org/packages/e1/eb/ae1f098969c9e9b81e821fb8e916cbf720b900ec1c0f3359e47a427395ec
PYTHON_PYTRIE_SETUP_TYPE = setuptools

$(eval $(python-package))
