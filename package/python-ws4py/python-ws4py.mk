################################################################################
#
# python-ws4py
#
################################################################################

PYTHON_WS4PY_VERSION = 0.3.5
PYTHON_WS4PY_SOURCE = ws4py-$(PYTHON_WS4PY_VERSION).tar.gz
PYTHON_WS4PY_SITE = https://pypi.python.org/packages/c8/b4/1784512791fbd196a48f282ca6c79398cace9541a9c151d89c30b6add6e1
PYTHON_WS4PY_SETUP_TYPE = setuptools
PYTHON_WS4PY_LICENSE = BSD-3c
PYTHON_WS4PY_LICENSE_FILES = ws4py/__init__.py

$(eval $(python-package))
