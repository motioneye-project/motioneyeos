################################################################################
#
# python-pymongo
#
################################################################################

PYTHON_PYMONGO_VERSION = 3.8.0
PYTHON_PYMONGO_SOURCE = pymongo-$(PYTHON_PYMONGO_VERSION).tar.gz
PYTHON_PYMONGO_SITE = https://files.pythonhosted.org/packages/19/77/da358f5729ff046ceaf6c6a86755f9d8285719f93df6da15bb2440367d7e
PYTHON_PYMONGO_SETUP_TYPE = setuptools

$(eval $(python-package))
