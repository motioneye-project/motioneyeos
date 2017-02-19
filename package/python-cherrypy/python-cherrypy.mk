################################################################################
#
# python-cherrypy
#
################################################################################

PYTHON_CHERRYPY_VERSION = 10.1.1
PYTHON_CHERRYPY_SOURCE = CherryPy-$(PYTHON_CHERRYPY_VERSION).tar.gz
PYTHON_CHERRYPY_SITE = https://pypi.python.org/packages/da/e2/6ed242ebfe96912e0866cc01139027d342d52c35ad33ee182bfb671c177d
PYTHON_CHERRYPY_LICENSE = BSD-3c
PYTHON_CHERRYPY_LICENSE_FILES = cherrypy/LICENSE.txt
PYTHON_CHERRYPY_SETUP_TYPE = distutils

$(eval $(python-package))
