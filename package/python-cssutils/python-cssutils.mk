################################################################################
#
# python-cssutils
#
################################################################################

PYTHON_CSSUTILS_VERSION = 1.0.2
PYTHON_CSSUTILS_SOURCE = cssutils-$(PYTHON_CSSUTILS_VERSION).tar.gz
PYTHON_CSSUTILS_SITE = https://files.pythonhosted.org/packages/5c/0b/c5f29d29c037e97043770b5e7c740b6252993e4b57f029b3cd03c78ddfec
PYTHON_CSSUTILS_LICENSE = LGPL-3.0+
PYTHON_CSSUTILS_LICENSE_FILES = COPYING.LESSER
PYTHON_CSSUTILS_SETUP_TYPE = setuptools

$(eval $(python-package))
