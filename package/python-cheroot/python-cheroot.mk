################################################################################
#
# python-cheroot
#
################################################################################

PYTHON_CHEROOT_VERSION = 5.10.0
PYTHON_CHEROOT_SOURCE = cheroot-$(PYTHON_CHEROOT_VERSION).tar.gz
PYTHON_CHEROOT_SITE = https://pypi.python.org/packages/14/dc/afc41e7f7e797973808d8520e6aef21c4efd00550aa32f5b726327d36be0
PYTHON_CHEROOT_LICENSE = BSD-3-Clause
PYTHON_CHEROOT_LICENSE_FILES = LICENSE
PYTHON_CHEROOT_SETUP_TYPE = setuptools
PYTHON_CHEROOT_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
