################################################################################
#
# python-dpkt
#
################################################################################

PYTHON_DPKT_VERSION = 1.7
PYTHON_DPKT_SOURCE  = dpkt-$(PYTHON_DPKT_VERSION).tar.gz
PYTHON_DPKT_SITE    = http://dpkt.googlecode.com/files
PYTHON_DPKT_SETUP_TYPE = distutils

$(eval $(python-package))
