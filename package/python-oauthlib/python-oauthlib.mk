################################################################################
#
# python-oauthlib
#
################################################################################

PYTHON_OAUTHLIB_VERSION = 3.0.2
PYTHON_OAUTHLIB_SOURCE = oauthlib-$(PYTHON_OAUTHLIB_VERSION).tar.gz
PYTHON_OAUTHLIB_SITE = https://files.pythonhosted.org/packages/6a/cf/f1a44998f36c62a7a9e51145101428299be27b1e3a411adfd6fd87589889
PYTHON_OAUTHLIB_SETUP_TYPE = setuptools
PYTHON_OAUTHLIB_LICENSE = BSD-3-Clause
PYTHON_OAUTHLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
