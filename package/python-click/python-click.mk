################################################################################
#
# python-click
#
################################################################################

PYTHON_CLICK_VERSION = 6.2
PYTHON_CLICK_SOURCE = click-$(PYTHON_CLICK_VERSION).tar.gz
PYTHON_CLICK_SITE = http://pypi.python.org/packages/source/c/click
PYTHON_CLICK_LICENSE = BSD-3c
PYTHON_CLICK_LICENSE_FILES = LICENSE
PYTHON_CLICK_SETUP_TYPE = setuptools

$(eval $(python-package))
