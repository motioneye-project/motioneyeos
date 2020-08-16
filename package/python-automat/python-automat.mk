################################################################################
#
# python-automat
#
################################################################################

PYTHON_AUTOMAT_VERSION = 20.2.0
PYTHON_AUTOMAT_SOURCE = Automat-$(PYTHON_AUTOMAT_VERSION).tar.gz
PYTHON_AUTOMAT_SITE = https://files.pythonhosted.org/packages/80/c5/82c63bad570f4ef745cc5c2f0713c8eddcd07153b4bee7f72a8dc9f9384b
PYTHON_AUTOMAT_SETUP_TYPE = setuptools
PYTHON_AUTOMAT_LICENSE = MIT
PYTHON_AUTOMAT_LICENSE_FILES = LICENSE
PYTHON_AUTOMAT_DEPENDENCIES = host-python-m2r host-python-setuptools-scm

$(eval $(python-package))
