################################################################################
#
# python-more-itertools
#
################################################################################

PYTHON_MORE_ITERTOOLS_VERSION = 7.2.0
PYTHON_MORE_ITERTOOLS_SOURCE = more-itertools-$(PYTHON_MORE_ITERTOOLS_VERSION).tar.gz
PYTHON_MORE_ITERTOOLS_SITE = https://files.pythonhosted.org/packages/c2/31/45f61c8927c9550109f1c4b99ba3ca66d328d889a9c9853a808bff1c9fa0
PYTHON_MORE_ITERTOOLS_SETUP_TYPE = setuptools
PYTHON_MORE_ITERTOOLS_LICENSE = MIT
PYTHON_MORE_ITERTOOLS_LICENSE_FILES = LICENSE

$(eval $(python-package))
