################################################################################
#
# python-semver
#
################################################################################

PYTHON_SEMVER_VERSION = 2.9.0
PYTHON_SEMVER_SOURCE = semver-$(PYTHON_SEMVER_VERSION).tar.gz
PYTHON_SEMVER_SITE = https://files.pythonhosted.org/packages/be/c8/392e3c1c4080202b99e8b3b5d0ab6cbcfc4b25d50031c2c21d130871bf88
PYTHON_SEMVER_SETUP_TYPE = setuptools
PYTHON_SEMVER_LICENSE = BSD-3-Clause
PYTHON_SEMVER_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
