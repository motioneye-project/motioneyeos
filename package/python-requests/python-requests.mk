################################################################################
#
# python-requests
#
################################################################################

PYTHON_REQUESTS_VERSION = 2.4.3
PYTHON_REQUESTS_SOURCE = requests-$(PYTHON_REQUESTS_VERSION).tar.gz
PYTHON_REQUESTS_SITE = http://pypi.python.org/packages/source/r/requests
PYTHON_REQUESTS_SETUP_TYPE = setuptools
PYTHON_REQUESTS_LICENSE = Apache-2.0
PYTHON_REQUESTS_LICENSE_FILES = LICENSE

$(eval $(python-package))
