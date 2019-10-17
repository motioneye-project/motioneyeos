################################################################################
#
# python3-setuptools
#
################################################################################

# Please keep in sync with
# package/python-setuptools/python-setuptools.mk
PYTHON3_SETUPTOOLS_VERSION = 41.4.0
PYTHON3_SETUPTOOLS_SOURCE = setuptools-$(PYTHON3_SETUPTOOLS_VERSION).zip
PYTHON3_SETUPTOOLS_SITE = https://files.pythonhosted.org/packages/f4/d5/a6c19dcbcbc267aca376558797f036d9bcdff344c9f785fe7d0fe9a5f2a7
PYTHON3_SETUPTOOLS_LICENSE = MIT
PYTHON3_SETUPTOOLS_LICENSE_FILES = LICENSE
PYTHON3_SETUPTOOLS_SETUP_TYPE = setuptools
HOST_PYTHON3_SETUPTOOLS_DL_SUBDIR = python-setuptools
HOST_PYTHON3_SETUPTOOLS_NEEDS_HOST_PYTHON = python3

define HOST_PYTHON3_SETUPTOOLS_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(HOST_PYTHON3_SETUPTOOLS_DL_DIR)/$(PYTHON3_SETUPTOOLS_SOURCE)
	mv $(@D)/setuptools-$(PYTHON3_SETUPTOOLS_VERSION)/* $(@D)
	$(RM) -r $(@D)/setuptools-$(PYTHON3_SETUPTOOLS_VERSION)
endef

$(eval $(host-python-package))
