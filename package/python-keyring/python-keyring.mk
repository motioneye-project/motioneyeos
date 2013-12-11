################################################################################
#
# python-keyring
#
################################################################################

PYTHON_KEYRING_VERSION = 3.0.5
PYTHON_KEYRING_SOURCE = keyring-$(PYTHON_KEYRING_VERSION).zip
PYTHON_KEYRING_SITE = http://pypi.python.org/packages/source/k/keyring/
PYTHON_KEYRING_SETUP_TYPE = setuptools
PYTHON_KEYRING_LICENSE = python software foundation license

define PYTHON_KEYRING_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(PYTHON_KEYRING_SOURCE)
	mv $(@D)/keyring-$(PYTHON_KEYRING_VERSION)/* $(@D)
	$(RM) -r $(@D)/keyring-$(PYTHON_KEYRING_VERSION)
endef

$(eval $(python-package))
