################################################################################
#
# python-tabledata
#
################################################################################

PYTHON_TABLEDATA_VERSION = 1.1.2
PYTHON_TABLEDATA_SOURCE = tabledata-$(PYTHON_TABLEDATA_VERSION).tar.gz
PYTHON_TABLEDATA_SITE = https://files.pythonhosted.org/packages/73/7c/67eec8e92504b8e00e5cc0053a3401bd1441eefc70cecfa4427bfcf76b89
PYTHON_TABLEDATA_SETUP_TYPE = setuptools
PYTHON_TABLEDATA_LICENSE = MIT
PYTHON_TABLEDATA_LICENSE_FILES = LICENSE

$(eval $(python-package))
