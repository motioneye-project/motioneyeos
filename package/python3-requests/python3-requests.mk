################################################################################
#
# python3-requests
#
################################################################################

# Please keep in sync with package/python-requests/python-requests.mk
PYTHON3_REQUESTS_VERSION = 2.23.0
PYTHON3_REQUESTS_SOURCE = requests-$(PYTHON3_REQUESTS_VERSION).tar.gz
PYTHON3_REQUESTS_SITE = https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915
PYTHON3_REQUESTS_SETUP_TYPE = setuptools
PYTHON3_REQUESTS_LICENSE = Apache-2.0
PYTHON3_REQUESTS_LICENSE_FILES = LICENSE
HOST_PYTHON3_REQUESTS_DL_SUBDIR = python-requests
HOST_PYTHON3_REQUESTS_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
