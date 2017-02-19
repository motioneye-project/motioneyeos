################################################################################
#
# python-requests-toolbelt
#
################################################################################

PYTHON_REQUESTS_TOOLBELT_VERSION = 0.7.1
PYTHON_REQUESTS_TOOLBELT_SOURCE = requests-toolbelt-$(PYTHON_REQUESTS_TOOLBELT_VERSION).tar.gz
PYTHON_REQUESTS_TOOLBELT_SITE = https://pypi.python.org/packages/ab/bf/2af6b25f880e2d529a524f98837d33b1048a2a15703fc4806185b54e9672
PYTHON_REQUESTS_TOOLBELT_SETUP_TYPE = setuptools
PYTHON_REQUESTS_TOOLBELT_LICENSE = Apache-2.0
PYTHON_REQUESTS_TOOLBELT_LICENSE_FILES = LICENSE

$(eval $(python-package))
