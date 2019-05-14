################################################################################
#
# python-scapy
#
################################################################################

PYTHON_SCAPY_VERSION = 2.4.0
PYTHON_SCAPY_SOURCE = scapy-$(PYTHON_SCAPY_VERSION).tar.gz
PYTHON_SCAPY_SITE = https://files.pythonhosted.org/packages/68/01/b9943984447e7ea6f8948e90c1729b78161c2bb3eef908430638ec3f7296
PYTHON_SCAPY_LICENSE = GPL-2.0
PYTHON_SCAPY_LICENSE_FILES = PKG-INFO
PYTHON_SCAPY_SETUP_TYPE = distutils

$(eval $(python-package))
