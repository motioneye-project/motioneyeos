################################################################################
#
# python-cherrypy
#
################################################################################

PYTHON_CHERRYPY_VERSION = 12.0.1
PYTHON_CHERRYPY_SOURCE = CherryPy-$(PYTHON_CHERRYPY_VERSION).tar.gz
PYTHON_CHERRYPY_SITE = https://pypi.python.org/packages/be/d8/a8ef56bfe1c39d466b8d55b496b64459cc43dec71361d88edf904901637f
PYTHON_CHERRYPY_LICENSE = BSD-3-Clause
PYTHON_CHERRYPY_LICENSE_FILES = LICENSE.md
PYTHON_CHERRYPY_SETUP_TYPE = setuptools
PYTHON_CHERRYPY_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
