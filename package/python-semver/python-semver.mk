################################################################################
#
# python-semver
#
################################################################################

PYTHON_SEMVER_VERSION = 2.8.1
PYTHON_SEMVER_SOURCE = semver-$(PYTHON_SEMVER_VERSION).tar.gz
PYTHON_SEMVER_SITE = https://files.pythonhosted.org/packages/47/13/8ae74584d6dd33a1d640ea27cd656a9f718132e75d759c09377d10d64595
PYTHON_SEMVER_SETUP_TYPE = setuptools
# no license file in tarball, but available in git
PYTHON_SEMVER_LICENSE = BSD-3-Clause

$(eval $(python-package))
