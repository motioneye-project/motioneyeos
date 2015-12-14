################################################################################
#
# python-webpy
#
################################################################################

PYTHON_WEBPY_VERSION = 0.37
PYTHON_WEBPY_SOURCE = web.py-$(PYTHON_WEBPY_VERSION).tar.gz
PYTHON_WEBPY_SITE = https://pypi.python.org/packages/source/w/web.py
PYTHON_WEBPY_SETUP_TYPE = distutils
PYTHON_WEBPY_LICENSE = Public Domain, CherryPy License
PYTHON_WEBPY_LICENSE_FILES = LICENSE.txt web/wsgiserver/LICENSE.txt

$(eval $(python-package))
