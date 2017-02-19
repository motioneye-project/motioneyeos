################################################################################
#
# python-cssutils
#
################################################################################

PYTHON_CSSUTILS_VERSION = 1.0.1
PYTHON_CSSUTILS_SOURCE = cssutils-$(PYTHON_CSSUTILS_VERSION).tar.gz
PYTHON_CSSUTILS_SITE = https://pypi.python.org/packages/22/de/6b03e0088baf0299ab7d2e95a9e26c2092e9cb3855876b958b6a62175ca2
PYTHON_CSSUTILS_LICENSE = LGPLv3+
PYTHON_CSSUTILS_LICENSE_FILES = COPYING.LESSER
PYTHON_CSSUTILS_SETUP_TYPE = setuptools

$(eval $(python-package))
