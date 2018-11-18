################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.9.1
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://files.pythonhosted.org/packages/1b/9b/c790760100c336e596b99ad13537fda36c13ea6f289b88594e9ad0d90a1e
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = mwclient/__init__.py
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
