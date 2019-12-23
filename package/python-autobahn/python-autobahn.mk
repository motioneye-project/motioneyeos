################################################################################
#
# python-autobahn
#
################################################################################

PYTHON_AUTOBAHN_VERSION = 19.11.1
PYTHON_AUTOBAHN_SOURCE = autobahn-$(PYTHON_AUTOBAHN_VERSION).tar.gz
PYTHON_AUTOBAHN_SITE = https://files.pythonhosted.org/packages/3f/f4/e907b172d3c1d912b8da57560b8b298ebad22f900f8a412002247716328a
PYTHON_AUTOBAHN_LICENSE = MIT
PYTHON_AUTOBAHN_LICENSE_FILES = LICENSE
PYTHON_AUTOBAHN_SETUP_TYPE = setuptools

$(eval $(python-package))
