################################################################################
#
# python-ipaddr
#
################################################################################

PYTHON_IPADDR_VERSION = 2.2.0
PYTHON_IPADDR_SOURCE = ipaddr-$(PYTHON_IPADDR_VERSION).tar.gz
PYTHON_IPADDR_SITE = https://files.pythonhosted.org/packages/9d/a7/1b39a16cb90dfe491f57e1cab3103a15d4e8dd9a150872744f531b1106c1
PYTHON_IPADDR_SETUP_TYPE = distutils
PYTHON_IPADDR_LICENSE = Apache-2.0
PYTHON_IPADDR_LICENSE_FILES = COPYING

$(eval $(python-package))
