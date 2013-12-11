################################################################################
#
# python-pyusb
#
################################################################################

PYTHON_PYUSB_VERSION = 0546cad8980783c39f96db717005a550059b730f
PYTHON_PYUSB_SITE = $(call github,walac,pyusb,$(PYTHON_PYUSB_VERSION))
PYTHON_PYUSB_LICENSE = BSD-3c
PYTHON_PYUSB_LICENSE_FILES = LICENSE
PYTHON_PYUSB_SETUP_TYPE = distutils
PYTHON_PYUSB_DEPENDENCIES = libusb

$(eval $(python-package))
