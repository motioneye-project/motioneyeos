################################################################################
#
# python-ipaddress
#
################################################################################

PYTHON_IPADDRESS_VERSION = 1.0.17
PYTHON_IPADDRESS_SOURCE = ipaddress-$(PYTHON_IPADDRESS_VERSION).tar.gz
PYTHON_IPADDRESS_SITE = https://pypi.python.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a
PYTHON_IPADDRESS_LICENSE = Python software foundation license
PYTHON_IPADDRESS_LICENSE_FILES = LICENSE
PYTHON_IPADDRESS_SETUP_TYPE = setuptools

$(eval $(python-package))
