################################################################################
#
# python-simplejson
#
################################################################################

PYTHON_SIMPLEJSON_VERSION = 3.16.0
PYTHON_SIMPLEJSON_SOURCE = simplejson-$(PYTHON_SIMPLEJSON_VERSION).tar.gz
PYTHON_SIMPLEJSON_SITE = https://files.pythonhosted.org/packages/e3/24/c35fb1c1c315fc0fffe61ea00d3f88e85469004713dab488dee4f35b0aff
PYTHON_SIMPLEJSON_LICENSE = Academic Free License (AFL), MIT
PYTHON_SIMPLEJSON_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
