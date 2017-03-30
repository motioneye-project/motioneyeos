################################################################################
#
# python-netaddr
#
################################################################################

PYTHON_NETADDR_VERSION = 0.7.19
PYTHON_NETADDR_SOURCE = netaddr-$(PYTHON_NETADDR_VERSION).tar.gz
PYTHON_NETADDR_SITE = https://pypi.python.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0
PYTHON_NETADDR_LICENSE = BSD-3-Clause
PYTHON_NETADDR_LICENSE_FILES = LICENSE
PYTHON_NETADDR_SETUP_TYPE = distutils

$(eval $(python-package))
