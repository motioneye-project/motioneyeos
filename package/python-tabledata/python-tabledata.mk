################################################################################
#
# python-tabledata
#
################################################################################

PYTHON_TABLEDATA_VERSION = 0.9.1
PYTHON_TABLEDATA_SOURCE = tabledata-$(PYTHON_TABLEDATA_VERSION).tar.gz
PYTHON_TABLEDATA_SITE = https://files.pythonhosted.org/packages/7d/20/7178ce0e3e34d5aff07e2280522b7e1bc23d4f2fbb916b765bbb41b22174
PYTHON_TABLEDATA_SETUP_TYPE = setuptools
PYTHON_TABLEDATA_LICENSE = MIT
PYTHON_TABLEDATA_LICENSE_FILES = LICENSE

$(eval $(python-package))
