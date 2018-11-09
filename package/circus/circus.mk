################################################################################
#
# circus
#
################################################################################

CIRCUS_VERSION = 0.14.0
CIRCUS_SITE = https://pypi.python.org/packages/68/41/02c6f5edea2df80b133a12753aee3e698e9130a5c878a9b0bffcf1e17e65
CIRCUS_SETUP_TYPE = setuptools
CIRCUS_LICENSE = Apache-2.0
CIRCUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
