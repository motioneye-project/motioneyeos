################################################################################
#
# python-pymysql
#
################################################################################

PYTHON_PYMYSQL_VERSION = 0.7.2
PYTHON_PYMYSQL_SOURCE = PyMySQL-$(PYTHON_PYMYSQL_VERSION).tar.gz
PYTHON_PYMYSQL_SITE = https://pypi.python.org/packages/source/P/PyMySQL
PYTHON_PYMYSQL_LICENSE = MIT
PYTHON_PYMYSQL_LICENSE_FILES = LICENSE
PYTHON_PYMYSQL_SETUP_TYPE = setuptools

$(eval $(python-package))
