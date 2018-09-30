################################################################################
#
# python-ipaddress
#
################################################################################

PYTHON_IPADDRESS_VERSION = 1.0.22
PYTHON_IPADDRESS_SOURCE = ipaddress-$(PYTHON_IPADDRESS_VERSION).tar.gz
PYTHON_IPADDRESS_SITE = https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f
PYTHON_IPADDRESS_LICENSE = Python-2.0
PYTHON_IPADDRESS_LICENSE_FILES = LICENSE
PYTHON_IPADDRESS_SETUP_TYPE = setuptools

$(eval $(python-package))
