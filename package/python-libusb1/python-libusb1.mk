################################################################################
#
# python-libusb1
#
################################################################################

PYTHON_LIBUSB1_VERSION = 1.6.4
PYTHON_LIBUSB1_SOURCE = libusb1-$(PYTHON_LIBUSB1_VERSION).tar.gz
PYTHON_LIBUSB1_SITE = https://pypi.python.org/packages/ec/5d/4fdac6c53525786fe35cff035c3345452e24e2bee5627893be65d12555cb
PYTHON_LIBUSB1_SETUP_TYPE = setuptools
PYTHON_LIBUSB1_LICENSE = LGPL-2.1+
PYTHON_LIBUSB1_LICENSE_FILES = COPYING.LESSER
PYTHON_LIBUSB1_DEPENDENCIES = libusb

$(eval $(python-package))
