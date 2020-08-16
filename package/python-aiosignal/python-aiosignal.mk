################################################################################
#
# python-aiosignal
#
################################################################################

PYTHON_AIOSIGNAL_VERSION = 1.0.0
PYTHON_AIOSIGNAL_SOURCE = aiosignal-$(PYTHON_AIOSIGNAL_VERSION).tar.gz
PYTHON_AIOSIGNAL_SITE = https://files.pythonhosted.org/packages/ca/b7/5ae01ed039ea51cc8280d87b8a1269ba2f1343d7466c1e50c618558352e5
PYTHON_AIOSIGNAL_SETUP_TYPE = setuptools
PYTHON_AIOSIGNAL_LICENSE = Apache-2.0
PYTHON_AIOSIGNAL_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
