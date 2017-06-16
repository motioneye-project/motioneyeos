################################################################################
#
# python-cheroot
#
################################################################################

PYTHON_CHEROOT_VERSION = 5.5.0
PYTHON_CHEROOT_SOURCE = cheroot-$(PYTHON_CHEROOT_VERSION).tar.gz
PYTHON_CHEROOT_SITE = https://pypi.python.org/packages/a5/43/f8a461762dc62e9f273d4944fb8c140757c11a29c91c91d3fbd5fafb1570
PYTHON_CHEROOT_LICENSE = BSD-3-Clause
PYTHON_CHEROOT_LICENSE_FILES = LICENSE.md
PYTHON_CHEROOT_SETUP_TYPE = setuptools
PYTHON_CHEROOT_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
