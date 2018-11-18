################################################################################
#
# python-cssselect
#
################################################################################

PYTHON_CSSSELECT_VERSION = 1.0.3
PYTHON_CSSSELECT_SOURCE = cssselect-$(PYTHON_CSSSELECT_VERSION).tar.gz
PYTHON_CSSSELECT_SITE = https://pypi.python.org/packages/52/ea/f31e1d2e9eb130fda2a631e22eac369dc644e8807345fbed5113f2d6f92b
PYTHON_CSSSELECT_SETUP_TYPE = setuptools
PYTHON_CSSSELECT_LICENSE = BSD-3-Clause
PYTHON_CSSSELECT_LICENSE_FILES = LICENSE

$(eval $(python-package))
