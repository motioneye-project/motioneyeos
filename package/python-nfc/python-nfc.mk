################################################################################
#
# python-nfc
#
################################################################################

PYTHON_NFC_VERSION = 0.13.5
PYTHON_NFC_SITE = $(call github,nfcpy,nfcpy,v$(PYTHON_NFC_VERSION))
PYTHON_NFC_DEPENDENCIES = libusb libusb-compat
PYTHON_NFC_SETUP_TYPE = setuptools
PYTHON_NFC_LICENSE = EUPL-1.1+
PYTHON_NFC_LICENSE_FILES = LICENSE

$(eval $(python-package))
