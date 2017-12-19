################################################################################
#
# python-dpkt
#
################################################################################

PYTHON_DPKT_VERSION = 1.8.r98
PYTHON_DPKT_SITE = $(call github,kbandla,dpkt,$(PYTHON_DPKT_VERSION))
PYTHON_DPKT_SETUP_TYPE = distutils
PYTHON_DPKT_LICENSE = BSD-3-Clause
PYTHON_DPKT_LICENSE_FILES = LICENSE

$(eval $(python-package))
