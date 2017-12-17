################################################################################
#
# python-automat
#
################################################################################

PYTHON_AUTOMAT_VERSION = 0.6.0
PYTHON_AUTOMAT_SOURCE = Automat-$(PYTHON_AUTOMAT_VERSION).tar.gz
PYTHON_AUTOMAT_SITE = https://pypi.python.org/packages/de/05/b8e453085cf8a7f27bb1226596f4ccf5cc9e758377d60284f990bbdc592c
PYTHON_AUTOMAT_SETUP_TYPE = setuptools
PYTHON_AUTOMAT_LICENSE = MIT
PYTHON_AUTOMAT_LICENSE_FILES = LICENSE
PYTHON_AUTOMAT_DEPENDENCIES = host-python-m2r host-python-setuptools-scm

$(eval $(python-package))
