################################################################################
#
# python-typing-extensions
#
################################################################################

PYTHON_TYPING_EXTENSIONS_VERSION = 3.7.2
PYTHON_TYPING_EXTENSIONS_SOURCE = typing_extensions-$(PYTHON_TYPING_EXTENSIONS_VERSION).tar.gz
PYTHON_TYPING_EXTENSIONS_SITE = https://files.pythonhosted.org/packages/fa/aa/229f5c82d17d10d4ef318b5c22a8626a1c78fc97f80d3307035cf696681b
PYTHON_TYPING_EXTENSIONS_SETUP_TYPE = setuptools
PYTHON_TYPING_EXTENSIONS_LICENSE = Apache-2.0
PYTHON_TYPING_EXTENSIONS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
