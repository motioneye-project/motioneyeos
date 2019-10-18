################################################################################
#
# python-ipaddress
#
################################################################################

PYTHON_IPADDRESS_VERSION = 1.0.23
PYTHON_IPADDRESS_SOURCE = ipaddress-$(PYTHON_IPADDRESS_VERSION).tar.gz
PYTHON_IPADDRESS_SITE = https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9
PYTHON_IPADDRESS_LICENSE = Python-2.0
PYTHON_IPADDRESS_LICENSE_FILES = LICENSE
PYTHON_IPADDRESS_SETUP_TYPE = setuptools

$(eval $(python-package))
