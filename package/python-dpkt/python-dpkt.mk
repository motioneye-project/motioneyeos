################################################################################
#
# python-dpkt
#
################################################################################

PYTHON_DPKT_VERSION = 1.7
PYTHON_DPKT_SOURCE = dpkt-$(PYTHON_DPKT_VERSION).tar.gz
PYTHON_DPKT_SITE = http://dpkt.googlecode.com/files
PYTHON_DPKT_SETUP_TYPE = distutils
PYTHON_DPKT_LICENSE = BSD-3c
PYTHON_DPKT_LICENSE_FILES = LICENSE

$(eval $(python-package))
