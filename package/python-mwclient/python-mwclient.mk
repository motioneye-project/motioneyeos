################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.8.7
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://pypi.python.org/packages/63/05/ddf7d1b0d3a1dc9ee650dcaef7ddfbb980b4d2f0c41128c5f9e6fed5e8e2
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = mwclient/__init__.py
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
