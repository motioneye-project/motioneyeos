################################################################################
#
# python-ipaddr
#
################################################################################

PYTHON_IPADDR_VERSION = 2.1.11
PYTHON_IPADDR_SOURCE = ipaddr-$(PYTHON_IPADDR_VERSION).tar.gz
PYTHON_IPADDR_SITE = http://pypi.python.org/packages/source/i/ipaddr
PYTHON_IPADDR_SETUP_TYPE = distutils
PYTHON_IPADDR_LICENSE = Apache-2.0
PYTHON_IPADDR_LICENSE_FILES = COPYING

$(eval $(python-package))
