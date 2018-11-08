################################################################################
#
# python-requests
#
################################################################################

PYTHON_REQUESTS_VERSION = 2.20.1
PYTHON_REQUESTS_SOURCE = requests-$(PYTHON_REQUESTS_VERSION).tar.gz
PYTHON_REQUESTS_SITE = https://files.pythonhosted.org/packages/40/35/298c36d839547b50822985a2cf0611b3b978a5ab7a5af5562b8ebe3e1369
PYTHON_REQUESTS_SETUP_TYPE = setuptools
PYTHON_REQUESTS_LICENSE = Apache-2.0
PYTHON_REQUESTS_LICENSE_FILES = LICENSE

$(eval $(python-package))
