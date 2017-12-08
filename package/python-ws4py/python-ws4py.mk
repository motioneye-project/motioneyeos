################################################################################
#
# python-ws4py
#
################################################################################

PYTHON_WS4PY_VERSION = 0.4.2
PYTHON_WS4PY_SOURCE = ws4py-$(PYTHON_WS4PY_VERSION).tar.gz
PYTHON_WS4PY_SITE = https://pypi.python.org/packages/b8/98/a90f1d96ffcb15dfc220af524ce23e0a5881258dafa197673357ce1683dd
PYTHON_WS4PY_SETUP_TYPE = setuptools
PYTHON_WS4PY_LICENSE = BSD-3-Clause
PYTHON_WS4PY_LICENSE_FILES = ws4py/__init__.py

$(eval $(python-package))
