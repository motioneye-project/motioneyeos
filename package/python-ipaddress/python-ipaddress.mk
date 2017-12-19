################################################################################
#
# python-ipaddress
#
################################################################################

PYTHON_IPADDRESS_VERSION = 1.0.18
PYTHON_IPADDRESS_SOURCE = ipaddress-$(PYTHON_IPADDRESS_VERSION).tar.gz
PYTHON_IPADDRESS_SITE = https://pypi.python.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06
PYTHON_IPADDRESS_LICENSE = Python-2.0
PYTHON_IPADDRESS_LICENSE_FILES = LICENSE
PYTHON_IPADDRESS_SETUP_TYPE = setuptools

$(eval $(python-package))
