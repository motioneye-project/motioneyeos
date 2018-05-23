################################################################################
#
# python-request-id
#
################################################################################

PYTHON_REQUEST_ID_VERSION = 0.3.1
PYTHON_REQUEST_ID_SOURCE = request-id-$(PYTHON_REQUEST_ID_VERSION).tar.gz
PYTHON_REQUEST_ID_SITE = https://files.pythonhosted.org/packages/2e/d4/bbe8cdd41012ba54d453452837101cecbb4151866b8aab6ca1ffb00d398c
PYTHON_REQUEST_ID_SETUP_TYPE = setuptools
PYTHON_REQUEST_ID_LICENSE = MIT
PYTHON_REQUEST_ID_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
