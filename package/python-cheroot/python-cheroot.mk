################################################################################
#
# python-cheroot
#
################################################################################

PYTHON_CHEROOT_VERSION = 5.9.0
PYTHON_CHEROOT_SOURCE = cheroot-$(PYTHON_CHEROOT_VERSION).tar.gz
PYTHON_CHEROOT_SITE = https://pypi.python.org/packages/df/63/5c5265feb7e02e43d2f3a3c19dbb2d78742b0a2ff237c9e473c77bc23500
PYTHON_CHEROOT_LICENSE = BSD-3-Clause
PYTHON_CHEROOT_LICENSE_FILES = LICENSE.md
PYTHON_CHEROOT_SETUP_TYPE = setuptools
PYTHON_CHEROOT_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
