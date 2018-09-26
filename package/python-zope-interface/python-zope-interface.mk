################################################################################
#
# python-zope-interface
#
################################################################################

PYTHON_ZOPE_INTERFACE_VERSION = 4.5.0
PYTHON_ZOPE_INTERFACE_SOURCE = zope.interface-$(PYTHON_ZOPE_INTERFACE_VERSION).tar.gz
PYTHON_ZOPE_INTERFACE_SITE = https://files.pythonhosted.org/packages/ac/8a/657532df378c2cd2a1fe6b12be3b4097521570769d4852ec02c24bd3594e
PYTHON_ZOPE_INTERFACE_SETUP_TYPE = setuptools
PYTHON_ZOPE_INTERFACE_LICENSE = ZPL-2.1
PYTHON_ZOPE_INTERFACE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
