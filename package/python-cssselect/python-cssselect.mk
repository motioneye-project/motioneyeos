################################################################################
#
# python-cssselect
#
################################################################################

PYTHON_CSSSELECT_VERSION = 0.9.2
PYTHON_CSSSELECT_SOURCE = cssselect-$(PYTHON_CSSSELECT_VERSION).tar.gz
PYTHON_CSSSELECT_SITE = https://pypi.python.org/packages/11/21/47b5d2696a945da177d2344b6e330b7b0d1c52404063cb387d2261517ccb
PYTHON_CSSSELECT_SETUP_TYPE = setuptools
PYTHON_CSSSELECT_LICENSE = BSD-3c
PYTHON_CSSSELECT_LICENSE_FILES = LICENSE

$(eval $(python-package))
