################################################################################
#
# python-scapy3k
#
################################################################################

PYTHON_SCAPY3K_VERSION = v0.18
PYTHON_SCAPY3K_SITE = $(call github,phaethon,scapy,$(PYTHON_SCAPY3K_VERSION))
PYTHON_SCAPY3K_SETUP_TYPE = distutils
PYTHON_SCAPY3K_LICENSE = GPLv2+

$(eval $(python-package))
