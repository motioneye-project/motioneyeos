################################################################################
#
# python-rtslib-fb
#
################################################################################

PYTHON_RTSLIB_FB_VERSION = v2.1.fb50
PYTHON_RTSLIB_FB_SITE = $(call github,agrover,rtslib-fb,$(PYTHON_RTSLIB_FB_VERSION))
PYTHON_RTSLIB_FB_LICENSE = Apache-2.0
PYTHON_RTSLIB_FB_LICENSE_FILES = COPYING
PYTHON_RTSLIB_FB_SETUP_TYPE = setuptools

$(eval $(python-package))
