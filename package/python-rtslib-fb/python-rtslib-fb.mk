################################################################################
#
# python-rtslib-fb
#
################################################################################

PYTHON_RTSLIB_FB_VERSION = 2.1.58
PYTHON_RTSLIB_FB_SOURCE = rtslib-fb-$(PYTHON_RTSLIB_FB_VERSION).tar.gz
PYTHON_RTSLIB_FB_SITE = https://pypi.python.org/packages/c8/26/ae0ff9a721d046bef78c457d8fc19287f7dbe36f98f5e190b017f0d9e9b7
PYTHON_RTSLIB_FB_LICENSE = Apache-2.0
PYTHON_RTSLIB_FB_LICENSE_FILES = setup.py
PYTHON_RTSLIB_FB_SETUP_TYPE = setuptools
PYTHON_RTSLIB_FB_DEPENDENCIES = python-six

$(eval $(python-package))
