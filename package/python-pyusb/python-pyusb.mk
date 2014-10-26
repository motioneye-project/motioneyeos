################################################################################
#
# python-pyusb
#
################################################################################

PYTHON_PYUSB_VERSION = 1.0.0b2
PYTHON_PYUSB_SITE = $(call github,walac,pyusb,$(PYTHON_PYUSB_VERSION))
PYTHON_PYUSB_LICENSE = BSD-3c
PYTHON_PYUSB_LICENSE_FILES = LICENSE
PYTHON_PYUSB_SETUP_TYPE = distutils
PYTHON_PYUSB_DEPENDENCIES = libusb

$(eval $(python-package))
