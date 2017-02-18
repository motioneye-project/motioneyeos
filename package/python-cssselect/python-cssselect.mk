################################################################################
#
# python-cssselect
#
################################################################################

PYTHON_CSSSELECT_VERSION = 0.9.1
PYTHON_CSSSELECT_SOURCE = cssselect-$(PYTHON_CSSSELECT_VERSION).tar.gz
PYTHON_CSSSELECT_SITE = https://pypi.python.org/packages/source/c/cssselect
PYTHON_CSSSELECT_SETUP_TYPE = setuptools
PYTHON_CSSSELECT_LICENSE = BSD-3c
PYTHON_CSSSELECT_LICENSE_FILES = LICENSE

$(eval $(python-package))
