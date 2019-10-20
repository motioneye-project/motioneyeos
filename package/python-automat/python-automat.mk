################################################################################
#
# python-automat
#
################################################################################

PYTHON_AUTOMAT_VERSION = 0.8.0
PYTHON_AUTOMAT_SOURCE = Automat-$(PYTHON_AUTOMAT_VERSION).tar.gz
PYTHON_AUTOMAT_SITE = https://files.pythonhosted.org/packages/4c/9a/3052851fa3a888d1ff32f053fba424ed929b47383fb5327855fdf70018cd
PYTHON_AUTOMAT_SETUP_TYPE = setuptools
PYTHON_AUTOMAT_LICENSE = MIT
PYTHON_AUTOMAT_LICENSE_FILES = LICENSE
PYTHON_AUTOMAT_DEPENDENCIES = host-python-m2r host-python-setuptools-scm

$(eval $(python-package))
