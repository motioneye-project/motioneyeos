################################################################################
#
# python-requests-oauthlib
#
################################################################################

PYTHON_REQUESTS_OAUTHLIB_VERSION = 1.2.0
PYTHON_REQUESTS_OAUTHLIB_SOURCE = requests-oauthlib-$(PYTHON_REQUESTS_OAUTHLIB_VERSION).tar.gz
PYTHON_REQUESTS_OAUTHLIB_SITE = https://files.pythonhosted.org/packages/de/a2/f55312dfe2f7a344d0d4044fdfae12ac8a24169dc668bd55f72b27090c32
PYTHON_REQUESTS_OAUTHLIB_SETUP_TYPE = setuptools
PYTHON_REQUESTS_OAUTHLIB_LICENSE = ISC
PYTHON_REQUESTS_OAUTHLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
