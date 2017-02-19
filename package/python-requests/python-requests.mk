################################################################################
#
# python-requests
#
################################################################################

PYTHON_REQUESTS_VERSION = 2.13.0
PYTHON_REQUESTS_SOURCE = requests-$(PYTHON_REQUESTS_VERSION).tar.gz
PYTHON_REQUESTS_SITE = https://pypi.python.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2
PYTHON_REQUESTS_SETUP_TYPE = setuptools
PYTHON_REQUESTS_LICENSE = Apache-2.0
PYTHON_REQUESTS_LICENSE_FILES = LICENSE

$(eval $(python-package))
