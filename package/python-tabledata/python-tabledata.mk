################################################################################
#
# python-tabledata
#
################################################################################

PYTHON_TABLEDATA_VERSION = 0.0.5
PYTHON_TABLEDATA_SOURCE = tabledata-$(PYTHON_TABLEDATA_VERSION).tar.gz
PYTHON_TABLEDATA_SITE = https://pypi.python.org/packages/9d/03/2e96d18f2bd4b76611fc6aa3881c7e15c857eea99debea9b80ec689354ba
PYTHON_TABLEDATA_SETUP_TYPE = setuptools
PYTHON_TABLEDATA_LICENSE = MIT
PYTHON_TABLEDATA_LICENSE_FILES = LICENSE

# remove setup.cfg as it tries to create a wheel file and hence
# breaks the build process
define PYTHON_TABLEDATA_REMOVE_SETUP_CFG
	rm $(@D)/setup.cfg
endef
PYTHON_TABLEDATA_POST_EXTRACT_HOOKS = PYTHON_TABLEDATA_REMOVE_SETUP_CFG

$(eval $(python-package))
