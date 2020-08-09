################################################################################
#
# python-webob
#
################################################################################

PYTHON_WEBOB_VERSION = 1.8.5
PYTHON_WEBOB_SOURCE = WebOb-$(PYTHON_WEBOB_VERSION).tar.gz
PYTHON_WEBOB_SITE = https://files.pythonhosted.org/packages/9d/1a/0c89c070ee2829c934cb6c7082287c822e28236a4fcf90063e6be7c35532
PYTHON_WEBOB_SETUP_TYPE = setuptools
PYTHON_WEBOB_LICENSE = MIT
PYTHON_WEBOB_LICENSE_FILES = docs/license.txt

$(eval $(python-package))
