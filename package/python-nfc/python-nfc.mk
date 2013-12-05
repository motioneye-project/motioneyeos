################################################################################
#
# python-nfc
#
################################################################################

PYTHON_NFC_VERSION = 142
PYTHON_NFC_SITE = https://launchpad.net/nfcpy
PYTHON_NFC_SITE_METHOD = bzr
PYTHON_NFC_DEPENDENCIES = python libusb libusb-compat

define PYTHON_NFC_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_NFC_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
