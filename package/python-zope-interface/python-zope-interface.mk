################################################################################
#
# python-zope-interface
#
################################################################################

PYTHON_ZOPE_INTERFACE_VERSION = 4.3.2
PYTHON_ZOPE_INTERFACE_SOURCE = zope.interface-$(PYTHON_ZOPE_INTERFACE_VERSION).tar.gz
PYTHON_ZOPE_INTERFACE_SITE = https://pypi.python.org/packages/38/1b/d55c39f2cf442bd9fb2c59760ed058c84b57d25c680819c25f3aff741e1f
PYTHON_ZOPE_INTERFACE_SETUP_TYPE = setuptools
PYTHON_ZOPE_INTERFACE_LICENSE = ZPLv2.1
PYTHON_ZOPE_INTERFACE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
