################################################################################
#
# python-html5lib
#
################################################################################

PYTHON_HTML5LIB_VERSION = 0.9999999
PYTHON_HTML5LIB_SOURCE = html5lib-$(PYTHON_HTML5LIB_VERSION).tar.gz
PYTHON_HTML5LIB_SITE = https://pypi.python.org/packages/source/h/html5lib
PYTHON_HTML5LIB_LICENSE = MIT
PYTHON_HTML5LIB_LICENSE_FILES = LICENSE
PYTHON_HTML5LIB_SETUP_TYPE = distutils

$(eval $(python-package))
