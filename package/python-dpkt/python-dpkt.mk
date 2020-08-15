################################################################################
#
# python-dpkt
#
################################################################################

PYTHON_DPKT_VERSION = 1.9.2
PYTHON_DPKT_SOURCE = dpkt-$(PYTHON_DPKT_VERSION).tar.gz
PYTHON_DPKT_SITE = https://files.pythonhosted.org/packages/1c/25/0aebea939ea70d31a7ff8884e5ca577eddb9cfeac626398fe782d4e2f6a2
PYTHON_DPKT_SETUP_TYPE = setuptools
PYTHON_DPKT_LICENSE = BSD-3-Clause
PYTHON_DPKT_LICENSE_FILES = LICENSE

$(eval $(python-package))
