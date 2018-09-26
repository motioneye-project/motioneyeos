################################################################################
#
# python-attrs
#
################################################################################

PYTHON_ATTRS_VERSION = 18.2.0
PYTHON_ATTRS_SOURCE = attrs-$(PYTHON_ATTRS_VERSION).tar.gz
PYTHON_ATTRS_SITE = https://files.pythonhosted.org/packages/0f/9e/26b1d194aab960063b266170e53c39f73ea0d0d3f5ce23313e0ec8ee9bdf
PYTHON_ATTRS_SETUP_TYPE = setuptools
PYTHON_ATTRS_LICENSE = MIT
PYTHON_ATTRS_LICENSE_FILES = LICENSE

$(eval $(python-package))
