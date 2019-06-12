################################################################################
#
# python-remi
#
################################################################################

PYTHON_REMI_VERSION = 1.1
PYTHON_REMI_SITE = $(call github,dddomodossola,remi,v$(PYTHON_REMI_VERSION))
PYTHON_REMI_LICENSE = Apache-2.0
PYTHON_REMI_LICENSE_FILES = LICENSE
PYTHON_REMI_SETUP_TYPE = setuptools

$(eval $(python-package))
