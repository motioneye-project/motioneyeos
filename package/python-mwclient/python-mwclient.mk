################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.8.1
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://pypi.python.org/packages/19/79/481b288a497f625ee8f76141ff3472d81428b1f14b7155a28a63a3247197
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = mwclient/__init__.py
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
