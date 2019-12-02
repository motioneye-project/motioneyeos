################################################################################
#
# python-dnspython
#
################################################################################

PYTHON_DNSPYTHON_VERSION = 1.16.0
PYTHON_DNSPYTHON_SOURCE = dnspython-$(PYTHON_DNSPYTHON_VERSION).zip
PYTHON_DNSPYTHON_SITE = https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed
PYTHON_DNSPYTHON_LICENSE = ISC
PYTHON_DNSPYTHON_LICENSE_FILES = LICENSE
PYTHON_DNSPYTHON_SETUP_TYPE = setuptools

define PYTHON_DNSPYTHON_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(PYTHON_DNSPYTHON_DL_DIR)/$(PYTHON_DNSPYTHON_SOURCE)
	mv $(@D)/dnspython-$(PYTHON_DNSPYTHON_VERSION)/* $(@D)
	$(RM) -r $(@D)/dnspython-$(PYTHON_DNSPYTHON_VERSION)
endef

$(eval $(python-package))
