################################################################################
#
# python-setuptools
#
################################################################################

# Please keep in sync with
# package/python3-setuptools/python3-setuptools.mk
PYTHON_SETUPTOOLS_VERSION = 41.4.0
PYTHON_SETUPTOOLS_SOURCE = setuptools-$(PYTHON_SETUPTOOLS_VERSION).zip
PYTHON_SETUPTOOLS_SITE = https://files.pythonhosted.org/packages/f4/d5/a6c19dcbcbc267aca376558797f036d9bcdff344c9f785fe7d0fe9a5f2a7
PYTHON_SETUPTOOLS_LICENSE = MIT
PYTHON_SETUPTOOLS_LICENSE_FILES = LICENSE
PYTHON_SETUPTOOLS_SETUP_TYPE = setuptools
HOST_PYTHON_SETUPTOOLS_NEEDS_HOST_PYTHON = python2

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
