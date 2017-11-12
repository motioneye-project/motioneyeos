################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.8.6
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://pypi.python.org/packages/cd/38/beaf985032b42a0b0c8f9028b469c4dcb0bd7bfab62707ec27af7e890e84
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = mwclient/__init__.py
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
