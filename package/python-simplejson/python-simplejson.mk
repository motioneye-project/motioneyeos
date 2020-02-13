################################################################################
#
# python-simplejson
#
################################################################################

PYTHON_SIMPLEJSON_VERSION = 3.17.0
PYTHON_SIMPLEJSON_SOURCE = simplejson-$(PYTHON_SIMPLEJSON_VERSION).tar.gz
PYTHON_SIMPLEJSON_SITE = https://files.pythonhosted.org/packages/98/87/a7b98aa9256c8843f92878966dc3d8d914c14aad97e2c5ce4798d5743e07
PYTHON_SIMPLEJSON_LICENSE = Academic Free License (AFL), MIT
PYTHON_SIMPLEJSON_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
