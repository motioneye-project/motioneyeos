################################################################################
#
# python-twisted
#
################################################################################

PYTHON_TWISTED_VERSION = 16.2.0
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VERSION).tar.bz2
PYTHON_TWISTED_SITE = https://pypi.python.org/packages/18/85/eb7af503356e933061bf1220033c3a85bad0dbc5035dfd9a97f1e900dfcb
PYTHON_TWISTED_SETUP_TYPE = setuptools
PYTHON_TWISTED_LICENSE = MIT
PYTHON_TWISTED_LICENSE_FILES = LICENSE

$(eval $(python-package))
