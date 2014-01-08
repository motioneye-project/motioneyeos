################################################################################
#
# python-nfc
#
################################################################################

PYTHON_NFC_VERSION = 212
PYTHON_NFC_SITE = https://launchpad.net/nfcpy
PYTHON_NFC_SITE_METHOD = bzr
PYTHON_NFC_DEPENDENCIES = libusb libusb-compat
PYTHON_NFC_SETUP_TYPE = distutils

$(eval $(python-package))
