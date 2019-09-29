################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.9.2
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://files.pythonhosted.org/packages/f8/5a/9a5cf29e256c5720b9dc3b60586be6557e5f8bbf313d90bf75b0d967f0af
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = mwclient/__init__.py
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
