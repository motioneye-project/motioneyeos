################################################################################
#
# python-setuptools
#
################################################################################

PYTHON_SETUPTOOLS_VERSION = 40.5.0
PYTHON_SETUPTOOLS_SOURCE = setuptools-$(PYTHON_SETUPTOOLS_VERSION).zip
PYTHON_SETUPTOOLS_SITE = https://files.pythonhosted.org/packages/26/e5/9897eee1100b166a61f91b68528cb692e8887300d9cbdaa1a349f6304b79
PYTHON_SETUPTOOLS_LICENSE = MIT
PYTHON_SETUPTOOLS_LICENSE_FILES = LICENSE
PYTHON_SETUPTOOLS_SETUP_TYPE = setuptools

define PYTHON_SETUPTOOLS_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(PYTHON_SETUPTOOLS_DL_DIR)/$(PYTHON_SETUPTOOLS_SOURCE)
	mv $(@D)/setuptools-$(PYTHON_SETUPTOOLS_VERSION)/* $(@D)
	$(RM) -r $(@D)/setuptools-$(PYTHON_SETUPTOOLS_VERSION)
endef

define HOST_PYTHON_SETUPTOOLS_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(HOST_PYTHON_SETUPTOOLS_DL_DIR)/$(PYTHON_SETUPTOOLS_SOURCE)
	mv $(@D)/setuptools-$(PYTHON_SETUPTOOLS_VERSION)/* $(@D)
	$(RM) -r $(@D)/setuptools-$(PYTHON_SETUPTOOLS_VERSION)
endef

$(eval $(python-package))
$(eval $(host-python-package))
