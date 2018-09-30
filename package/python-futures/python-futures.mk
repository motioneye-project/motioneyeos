################################################################################
#
# python-futures
#
################################################################################

PYTHON_FUTURES_VERSION = 3.2.0
PYTHON_FUTURES_SOURCE = futures-$(PYTHON_FUTURES_VERSION).tar.gz
PYTHON_FUTURES_SITE = https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb
PYTHON_FUTURES_SETUP_TYPE = setuptools
PYTHON_FUTURES_LICENSE = BSD-2-Clause
PYTHON_FUTURES_LICENSE_FILES = LICENSE

$(eval $(python-package))
