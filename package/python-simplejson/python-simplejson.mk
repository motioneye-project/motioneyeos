################################################################################
#
# python-simplejson
#
################################################################################

PYTHON_SIMPLEJSON_VERSION = 3.10.0
PYTHON_SIMPLEJSON_SOURCE = simplejson-$(PYTHON_SIMPLEJSON_VERSION).tar.gz
PYTHON_SIMPLEJSON_SITE = https://pypi.python.org/packages/40/ad/52c1f3a562df3b210e8f165e1aa243a178c454ead65476a39fa3ce1847b6
PYTHON_SIMPLEJSON_LICENSE = Academic Free License (AFL), MIT
PYTHON_SIMPLEJSON_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEJSON_SETUP_TYPE = setuptools

$(eval $(python-package))
