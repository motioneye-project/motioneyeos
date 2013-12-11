################################################################################
#
# python-pyasn
#
################################################################################

PYTHON_PYASN_VERSION = 1.2
PYTHON_PYASN_SOURCE = PyASN-$(PYTHON_PYASN_VERSION).zip
PYTHON_PYASN_SITE = https://pyasn.googlecode.com/files
PYTHON_PYASN_LICENSE = LGPLv3+ (pyasn.cpp), GPLv2+ (libgds)
PYTHON_PYASN_SETUP_TYPE = distutils

define PYTHON_PYASN_EXTRACT_CMDS
	unzip -d $(@D) $(DL_DIR)/$(PYTHON_PYASN_SOURCE)
	mv $(@D)/PyASN-$(PYTHON_PYASN_VERSION)/* $(@D)
	$(RM) -r $(@D)/PyASN-$(PYTHON_PYASN_VERSION)
endef

$(eval $(python-package))
