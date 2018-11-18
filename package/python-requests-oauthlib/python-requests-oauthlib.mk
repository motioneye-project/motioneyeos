################################################################################
#
# python-requests-oauthlib
#
################################################################################

PYTHON_REQUESTS_OAUTHLIB_VERSION = 1.0.0
PYTHON_REQUESTS_OAUTHLIB_SOURCE = requests-oauthlib-$(PYTHON_REQUESTS_OAUTHLIB_VERSION).tar.gz
PYTHON_REQUESTS_OAUTHLIB_SITE = https://files.pythonhosted.org/packages/95/be/072464f05b70e4142cb37151e215a2037b08b1400f8a56f2538b76ca6205
PYTHON_REQUESTS_OAUTHLIB_SETUP_TYPE = setuptools
PYTHON_REQUESTS_OAUTHLIB_LICENSE = ISC
PYTHON_REQUESTS_OAUTHLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
