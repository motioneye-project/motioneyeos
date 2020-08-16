################################################################################
#
# circus
#
################################################################################

CIRCUS_VERSION = 0.15.0
CIRCUS_SITE = https://files.pythonhosted.org/packages/12/11/b72ee03c3d1fd09c39466954def2eae176d22a9fa5d9e6e8e6b90ee88f56
CIRCUS_SETUP_TYPE = setuptools
CIRCUS_LICENSE = Apache-2.0
CIRCUS_LICENSE_FILES = LICENSE

$(eval $(python-package))
