################################################################################
#
# python-requests-oauthlib
#
################################################################################

PYTHON_REQUESTS_OAUTHLIB_VERSION = 0.8.0
PYTHON_REQUESTS_OAUTHLIB_SOURCE = requests-oauthlib-$(PYTHON_REQUESTS_OAUTHLIB_VERSION).tar.gz
PYTHON_REQUESTS_OAUTHLIB_SITE = https://pypi.python.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5
PYTHON_REQUESTS_OAUTHLIB_SETUP_TYPE = setuptools
PYTHON_REQUESTS_OAUTHLIB_LICENSE = ISC
PYTHON_REQUESTS_OAUTHLIB_LICENSE_FILES = LICENSE

$(eval $(python-package))
