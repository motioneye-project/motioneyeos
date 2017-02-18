################################################################################
#
# python-ipaddress
#
################################################################################

PYTHON_IPADDRESS_VERSION = 1.0.15
PYTHON_IPADDRESS_SOURCE = ipaddress-$(PYTHON_IPADDRESS_VERSION).tar.gz
PYTHON_IPADDRESS_SITE = https://pypi.python.org/packages/source/i/ipaddress
PYTHON_IPADDRESS_LICENSE = Python software foundation license
PYTHON_IPADDRESS_SETUP_TYPE = setuptools

$(eval $(python-package))
