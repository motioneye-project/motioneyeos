################################################################################
#
# python-ws4py
#
################################################################################

PYTHON_WS4PY_VERSION = 0.3.4
PYTHON_WS4PY_SOURCE = ws4py-$(PYTHON_WS4PY_VERSION).tar.gz
PYTHON_WS4PY_SITE = https://pypi.python.org/packages/source/w/ws4py
PYTHON_WS4PY_SETUP_TYPE = setuptools
PYTHON_WS4PY_LICENSE = BSD-3c
PYTHON_WS4PY_LICENSE_FILES = ws4py/__init__.py

$(eval $(python-package))
