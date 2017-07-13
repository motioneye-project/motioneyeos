################################################################################
#
# python-zope-interface
#
################################################################################

PYTHON_ZOPE_INTERFACE_VERSION = 4.4.2
PYTHON_ZOPE_INTERFACE_SOURCE = zope.interface-$(PYTHON_ZOPE_INTERFACE_VERSION).tar.gz
PYTHON_ZOPE_INTERFACE_SITE = https://pypi.python.org/packages/c5/88/93373971f893714f0dc15e09696ec4886ee8b4e561ce5ae45612c2c516c4
PYTHON_ZOPE_INTERFACE_SETUP_TYPE = setuptools
PYTHON_ZOPE_INTERFACE_LICENSE = ZPL-2.1
PYTHON_ZOPE_INTERFACE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
