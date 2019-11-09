################################################################################
#
# python-jsonpointer
#
################################################################################

PYTHON_JSONPOINTER_VERSION = 2.0
PYTHON_JSONPOINTER_SOURCE = jsonpointer-$(PYTHON_JSONPOINTER_VERSION).tar.gz
PYTHON_JSONPOINTER_SITE = https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f
PYTHON_JSONPOINTER_SETUP_TYPE = setuptools
PYTHON_JSONPOINTER_LICENSE = BSD
PYTHON_JSONPOINTER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
