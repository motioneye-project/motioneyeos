################################################################################
#
# python-sqlparse
#
################################################################################

PYTHON_SQLPARSE_VERSION = 0.3.0
PYTHON_SQLPARSE_SOURCE = sqlparse-$(PYTHON_SQLPARSE_VERSION).tar.gz
PYTHON_SQLPARSE_SITE = https://files.pythonhosted.org/packages/63/c8/229dfd2d18663b375975d953e2bdc06d0eed714f93dcb7732f39e349c438
PYTHON_SQLPARSE_SETUP_TYPE = setuptools
PYTHON_SQLPARSE_LICENSE = BSD-3-Clause
PYTHON_SQLPARSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
