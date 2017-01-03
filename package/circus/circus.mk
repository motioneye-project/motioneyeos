################################################################################
#
# circus
#
################################################################################

CIRCUS_VERSION = 0.13.0
CIRCUS_SITE = https://pypi.python.org/packages/source/c/circus
CIRCUS_SETUP_TYPE = setuptools
CIRCUS_LICENSE = Apache-2.0
CIRCUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
