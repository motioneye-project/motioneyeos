################################################################################
#
# python-pyxb
#
################################################################################

PYTHON_PYXB_VERSION = 1.2.4
PYTHON_PYXB_SITE = $(call github,pabigot,pyxb,PyXB-$(PYTHON_PYXB_VERSION))
PYTHON_PYXB_LICENSE = Apache-2.0
PYTHON_PYXB_LICENSE_FILES = LICENSE
PYTHON_PYXB_SETUP_TYPE = distutils

$(eval $(python-package))
