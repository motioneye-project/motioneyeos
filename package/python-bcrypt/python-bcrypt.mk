################################################################################
#
# python-bcrypt
#
################################################################################

PYTHON_BCRYPT_VERSION = 3.1.4
PYTHON_BCRYPT_SOURCE = bcrypt-$(PYTHON_BCRYPT_VERSION).tar.gz
PYTHON_BCRYPT_SITE = https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358
PYTHON_BCRYPT_SETUP_TYPE = setuptools
PYTHON_BCRYPT_LICENSE = Apache-2.0
PYTHON_BCRYPT_LICENSE_FILES = LICENSE
PYTHON_BCRYPT_DEPENDENCIES = host-python-cffi

$(eval $(python-package))
