################################################################################
#
# python-pymysql
#
################################################################################

PYTHON_PYMYSQL_VERSION = 0.9.3
PYTHON_PYMYSQL_SOURCE = PyMySQL-$(PYTHON_PYMYSQL_VERSION).tar.gz
PYTHON_PYMYSQL_SITE = https://files.pythonhosted.org/packages/da/15/23ba6592920e21cb40eb0fe0ea002d2b6177beb1ca8a4c1add5a8f32754d
PYTHON_PYMYSQL_LICENSE = MIT
PYTHON_PYMYSQL_LICENSE_FILES = LICENSE
PYTHON_PYMYSQL_SETUP_TYPE = setuptools

$(eval $(python-package))
