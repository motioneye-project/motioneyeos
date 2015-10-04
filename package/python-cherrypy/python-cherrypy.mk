################################################################################
#
# python-cherrypy
#
################################################################################

PYTHON_CHERRYPY_VERSION = 3.6.0
PYTHON_CHERRYPY_SOURCE = CherryPy-$(PYTHON_CHERRYPY_VERSION).tar.gz
PYTHON_CHERRYPY_SITE = http://pypi.python.org/packages/source/C/CherryPy
PYTHON_CHERRYPY_LICENSE = BSD-3c
PYTHON_CHERRYPY_LICENSE_FILES = cherrypy/LICENSE.txt
PYTHON_CHERRYPY_SETUP_TYPE = distutils

$(eval $(python-package))
