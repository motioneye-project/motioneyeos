################################################################################
#
# python-mwclient
#
################################################################################

PYTHON_MWCLIENT_VERSION = 0.10.0
PYTHON_MWCLIENT_SOURCE = mwclient-$(PYTHON_MWCLIENT_VERSION).tar.gz
PYTHON_MWCLIENT_SITE = https://files.pythonhosted.org/packages/c1/ec/6206a7b3834572b3c1082f58dc960f4e49543395aa55955b598c29c9f8ad
PYTHON_MWCLIENT_LICENSE = MIT
PYTHON_MWCLIENT_LICENSE_FILES = LICENSE.md
PYTHON_MWCLIENT_SETUP_TYPE = setuptools

$(eval $(python-package))
