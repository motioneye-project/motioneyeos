################################################################################
#
# python-scapy3k
#
################################################################################

PYTHON_SCAPY3K_VERSION = 0.18
PYTHON_SCAPY3K_SITE = $(call github,phaethon,scapy,v$(PYTHON_SCAPY3K_VERSION))
PYTHON_SCAPY3K_SETUP_TYPE = distutils
PYTHON_SCAPY3K_LICENSE = GPL-2.0+

$(eval $(python-package))
