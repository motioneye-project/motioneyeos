################################################################################
#
# python-simplejson
#
################################################################################

PYTHON_SIMPLEJSON_VERSION = 3.5.3
PYTHON_SIMPLEJSON_SOURCE = simplejson-$(PYTHON_SIMPLEJSON_VERSION).tar.gz
PYTHON_SIMPLEJSON_SITE = http://pypi.python.org/packages/source/s/simplejson/
PYTHON_SIMPLEJSON_LICENSE = MIT
PYTHON_SIMPLEJSON_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEJSON_SETUP_TYPE = distutils

$(eval $(python-package))
